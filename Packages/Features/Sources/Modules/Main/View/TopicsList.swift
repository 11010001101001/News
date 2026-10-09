import DesignSystem
import LocalizationKit
import SwiftUI

struct TopicsList: View {
    @Bindable var viewModel: MainViewModel

    var body: some View {
        GradientScrollView {
            Group {
                switch viewModel.loadingState {
                case .loading:
                    loader
                case .loaded:
                    list
                case .error(let message):
                    ErrorView(
                        title: message,
                        action: {
                            viewModel.impactOccured(.light)
                            viewModel.loadNews()
                        },
                        isCard: true
                    )
                }
            }
            .padding(.top, Constants.padding)
        }
        .safeAreaInset(edge: .top) {
            ConditionalView(viewModel.isOverheated) {
                ThermalBannerView()
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.isOverheated)
        .refreshable {
            viewModel.impactOccured(.light)
            viewModel.refresh()
        }
    }
}

// MARK: - Private
extension TopicsList {
    fileprivate var list: some View {
        VerStack {
            ForEach(viewModel.news, id: \.self) {
                ModuleBuilder.shared.build(.details($0))
            }
        }
    }

    fileprivate var loader: some View {
        VerStack(alignment: .center) {
            Spacer()
            Loader(
                loaderName: viewModel.loader,
                shadowColor: viewModel.loaderShadowColor
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .containerRelativeFrame(.vertical)
    }
}
