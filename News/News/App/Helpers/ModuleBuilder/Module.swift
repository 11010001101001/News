import Foundation

enum Module {
    case main
    case details(_ article: Article)
    case settings
    case favorites
}
