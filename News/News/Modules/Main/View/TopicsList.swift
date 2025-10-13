import SwiftUI

struct TopicsList: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var enderOpacity: CGFloat = .zero

    var body: some View {
        ZStack {
            list

            Loader(
                loaderName: viewModel.loader,
                shadowColor: viewModel.loaderShadowColor
            )
            .opacity(viewModel.loadingState.loaderOpacity)
            .id(viewModel.loaderId)

            ErrorView(
                title: viewModel.loadingState.errorMessage,
                action: {
                    viewModel.impactOccured(.light)
                    viewModel.loadNews()
                }
            )
            .padding(.horizontal, CGFloat.sideInsets)
            .opacity(viewModel.loadingState.errorOpacity)
        }
    }
}

// MARK: - Private
private extension TopicsList {
    var list: some View {
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
        .opacity(viewModel.loadingState.contentOpacity)
    }

    func buildTopic() -> some View {
        ForEach(viewModel.news, id: \.self) { article in
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
