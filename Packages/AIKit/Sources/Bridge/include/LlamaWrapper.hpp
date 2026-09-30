#pragma once

#include <llama/llama.h>
#include <memory>
#include <string>

namespace AIEngine {

class LocalLLM {
  private:
    llama_model *model = nullptr;
    llama_context *ctx = nullptr;

  public:
    LocalLLM() = default;
    ~LocalLLM();

    bool loadModel(const std::string &path, int ctxSize = 1024);
    std::string generate(const std::string &promt);
};
} // namespace AIEngine
