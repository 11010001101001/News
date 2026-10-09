//
//  File.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

#include "LlamaWrapper.hpp"
#include <chrono>
#include <iostream>
#include <thread>

namespace AIEngine {

LocalLLM::~LocalLLM() {
    if (ctx)
        llama_free(ctx);
    if (model)
        llama_free_model(model);
    llama_backend_free();
}

// Thread starvation -> Glitches resolved by n_gpu_layers = 0;
// Battery drain & heating resolved by caching in DetailsViewModel, limiting
// cores & gpu_layers number to 1, setting QOS_CLASS_BACKGROUND and
// std::this_thread::sleep_for(std::chrono::milliseconds(6));
bool LocalLLM::loadModel(const std::string &path, int ctxSize) {
    auto mparams = llama_model_default_params();
    mparams.n_gpu_layers = 0;

    model = llama_load_model_from_file(path.c_str(), mparams);
    if (!model)
        return false;

    auto cparams = llama_context_default_params();
    cparams.n_ctx = ctxSize;
    cparams.n_threads = 2;
    cparams.n_threads_batch = 2;
    ctx = llama_new_context_with_model(model, cparams);

    return ctx != nullptr;
}

std::string LocalLLM::generate(const std::string &promt) {
    if (!ctx || !model)
        return "Error: Model not loaded";

    llama_kv_cache_clear(ctx);

    int32_t length = static_cast<int32_t>(promt.length());

    int n_promt_tokens =
        -llama_tokenize(model, promt.c_str(), length, NULL, 0, false, true);

    std::vector<llama_token> promt_tokens(n_promt_tokens);

    if (llama_tokenize(model, promt.c_str(), length, promt_tokens.data(),
                       n_promt_tokens, false, true) < 0) {
        return "Error: Failed to tokenize promt";
    }

    llama_batch batch =
        llama_batch_get_one(promt_tokens.data(), n_promt_tokens, 0, 0);

    if (llama_decode(ctx, batch) != 0) {
        return "Error: Failed to decode promt";
    }

    std::string result = "";
    int max_tokens = 128;
    int32_t n_cur = static_cast<int32_t>(promt_tokens.size());

    for (int i = 0; i < max_tokens; ++i) {
        auto n_vocab = llama_n_vocab(model);
        auto *logits = llama_get_logits_ith(ctx, batch.n_tokens - 1);
        llama_token new_token_id = 0;
        float max_prob = -1e9f;

        for (llama_token id = 0; id < n_vocab; ++id) {
            if (logits[id] > max_prob) {
                max_prob = logits[id];
                new_token_id = id;
            }
        }

        if (new_token_id == llama_token_eos(model)) {
            break;
        }

        char buf[128];

        int n = llama_token_to_piece(model, new_token_id, buf, sizeof(buf));

        if (n > 0) {
            result.append(buf, n);
        }

        batch = llama_batch_get_one(&new_token_id, 1, n_cur++, 0);

        if (llama_decode(ctx, batch) != 0) {
            break;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(15));
    }

    return result.empty() ? "Error: Empty response" : result;
}
}; // namespace AIEngine
