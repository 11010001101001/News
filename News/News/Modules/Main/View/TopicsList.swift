import SwiftUI

struct TopicsList: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var enderOpacity: CGFloat = .zero

    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                buildTopicsList(proxy: proxy)

                Loader(
                    loaderName: viewModel.loader,
                    shadowColor: viewModel.loaderShadowColor
                )
                .opacity($viewModel.loadingSucceeded.wrappedValue ? .zero : 1.0)
                .id(viewModel.id)

                ErrorView(
                    title: $viewModel.errorMessage.wrappedValue,
                    action: {
                        viewModel.impactOccured(.light)
                        viewModel.loadNews()
                    }
                )
                .padding(.horizontal, CGFloat.sideInsets)
                .opacity($viewModel.loadingFailed.wrappedValue ? 1.0 : .zero)
            }
        }
    }
}

// MARK: - Private
private extension TopicsList {
    func buildTopicsList(proxy: ScrollViewProxy) -> some View {
        ScrollView(.vertical) {
            VerStack {
                buildTopic()
                buildScrollEnder()
            }
            .padding(.top, Constants.padding)
        }
        .refreshable {
            viewModel.impactOccured(.light)
            viewModel.refresh()
        }
        .opacity($viewModel.loadingSucceeded.wrappedValue ? 1.0 : .zero)
    }

    func buildTopic() -> some View {
        ForEach($viewModel.newsArray) { $article in
            ModuleBuilder.shared.build(.details(article))
        }
    }

    func buildScrollEnder() -> some View {
        HorStack {
            Spacer()
            viewModel.loaderShadowColor
                .clipShape(.rect(cornerRadius: Constants.cornerRadius))
                .gloss(color: viewModel.loaderShadowColor)
                .frame(width: 150, height: 1)
                .opacity(enderOpacity)
                .padding(.top, -Constants.padding)
                .onAppear {
                    withAnimation(.bouncy(duration: 2.0).repeatForever(autoreverses: true)) {
                        enderOpacity = 1
                    }
                }
            Spacer()
        }
    }
}
