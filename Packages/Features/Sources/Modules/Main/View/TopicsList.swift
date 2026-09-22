import SwiftUI
import DesignSystem

struct TopicsList: View {
    @Bindable var viewModel: MainViewModel

    var body: some View {
        ZStack {
            list
            gradient

            Loader(
                loaderName: viewModel.loader,
                shadowColor: viewModel.loaderShadowColor
            )
            .opacity(viewModel.loadingState.loaderOpacity)

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
extension TopicsList {
    fileprivate var list: some View {
        ScrollView(.vertical) {
            VerStack {
                ForEach(viewModel.news, id: \.self) {
                    ModuleBuilder.shared.build(.details($0))
                }
            }
            .padding(.top, Constants.padding)
        }
        .refreshable {
            viewModel.impactOccured(.light)
            viewModel.refresh()
        }
        .opacity(viewModel.loadingState.contentOpacity)
    }

    fileprivate var gradient: some View {
        VerStack {
            Spacer()
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: Constants.gradientHeight)
            .opacity(viewModel.loadingState.contentOpacity)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
