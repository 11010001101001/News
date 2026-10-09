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
            ConditionalView(viewModel.isOverheated) {
                ThermalBannerView()
                    .padding(.bottom, Constants.padding)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            ForEach(viewModel.news, id: \.self) {
                ModuleBuilder.shared.build(.details($0))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.isOverheated)
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
