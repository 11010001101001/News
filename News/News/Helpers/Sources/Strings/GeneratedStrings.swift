// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Texts {
  public enum Actions {
    /// Open
    public static func `open`() -> String { Texts.tr("Strings", "actions.open", fallback: "Open")
    }
    /// Reload
    public static func reload() -> String { Texts.tr("Strings", "actions.reload", fallback: "Reload")
    }
    /// Share
    public static func share() -> String { Texts.tr("Strings", "actions.share", fallback: "Share")
    }
    public enum Return {
      /// That's all for now.
      /// Read again?
      public static func message() -> String { Texts.tr("Strings", "actions.return.message", fallback: "That's all for now.\nRead again?")
      }
    }
  }
  public enum App {
    /// 8f825354e7354c71829cfb4cb15c4893
    public static func apiKey1() -> String { Texts.tr("Strings", "app.apiKey1", fallback: "8f825354e7354c71829cfb4cb15c4893")
    }
    /// eb4bc5c32bdd40ca937aa8f94ff2673a
    public static func apiKey2() -> String { Texts.tr("Strings", "app.apiKey2", fallback: "eb4bc5c32bdd40ca937aa8f94ff2673a")
    }
    /// contact us
    public static func contactUs() -> String { Texts.tr("Strings", "app.contactUs", fallback: "contact us")
    }
    /// https://t.me/Yaroslav_Kupriyanov
    public static func telegram() -> String { Texts.tr("Strings", "app.telegram", fallback: "https://t.me/Yaroslav_Kupriyanov")
    }
    /// app version: %@
    public static func version(_ p1: Any) -> String {
      return Texts.tr("Strings", "app.version", String(describing: p1), fallback: "app version: %@")
    }
  }
  public enum Errors {
    /// Error 400
    /// 
    /// Bad request, please try again later
    public static func badRequest() -> String { Texts.tr("Strings", "errors.badRequest", fallback: "Error 400\n\nBad request, please try again later")
    }
    /// Image loading failed
    public static func imageLoadingError() -> String { Texts.tr("Strings", "errors.imageLoadingError", fallback: "Image loading failed")
    }
    /// invalidUrl
    public static func invalidUrl() -> String { Texts.tr("Strings", "errors.invalidUrl", fallback: "invalidUrl")
    }
    /// mappingError
    public static func mappingError() -> String { Texts.tr("Strings", "errors.mappingError", fallback: "mappingError")
    }
    /// responseError
    public static func responseError() -> String { Texts.tr("Strings", "errors.responseError", fallback: "responseError")
    }
    /// Error 500
    /// 
    /// Server error, please try again later
    public static func serverError() -> String { Texts.tr("Strings", "errors.serverError", fallback: "Error 500\n\nServer error, please try again later")
    }
    /// Time - out
    /// error
    /// 
    /// Server problem or internet connection broken
    public static func timeout() -> String { Texts.tr("Strings", "errors.timeout", fallback: "Time - out\nerror\n\nServer problem or internet connection broken")
    }
    /// Error 429
    /// 
    /// Requests number per day exceeded, see you tommorow
    public static func tooManyRequests() -> String { Texts.tr("Strings", "errors.tooManyRequests", fallback: "Error 429\n\nRequests number per day exceeded, see you tommorow")
    }
    /// No description. It's not an error, press button below for more
    public static func topicLabelNoInfo() -> String { Texts.tr("Strings", "errors.topicLabelNoInfo", fallback: "No description. It's not an error, press button below for more")
    }
    /// Error 401
    /// 
    /// Request autorization failed, please try again later
    public static func unauthorized() -> String { Texts.tr("Strings", "errors.unauthorized", fallback: "Error 401\n\nRequest autorization failed, please try again later")
    }
    /// undefinedError
    public static func undefinedError() -> String { Texts.tr("Strings", "errors.undefinedError", fallback: "undefinedError")
    }
  }
  public enum Loading {
    public enum State {
      /// ok
      public static func ok() -> String { Texts.tr("Strings", "loading.state.ok", fallback: "ok")
      }
    }
  }
  public enum Notification {
    /// News carriage arrived, unload please 🦥
    public static func body() -> String { Texts.tr("Strings", "notification.body", fallback: "News carriage arrived, unload please 🦥")
    }
    /// Strings.strings
    ///   News
    /// 
    ///   Created by Yaroslav Kupriyanov on 17.11.2024.
    public static func title() -> String { Texts.tr("Strings", "notification.title", fallback: "Mmmmm, nice-ey")
    }
  }
  public enum Screen {
    public enum Details {
      /// Details
      public static func title() -> String { Texts.tr("Strings", "screen.details.title", fallback: "Details")
      }
    }
    public enum Main {
      /// News
      public static func title() -> String { Texts.tr("Strings", "screen.main.title", fallback: "News")
      }
    }
    public enum Settings {
      /// Settings
      public static func title() -> String { Texts.tr("Strings", "screen.settings.title", fallback: "Settings")
      }
    }
  }
  public enum Share {
    /// Link to News app in appStore 🦾: stay informed!👨🏻‍🔧
    public static func info() -> String { Texts.tr("Strings", "share.info", fallback: "Link to News app in appStore 🦾: stay informed!👨🏻‍🔧")
    }
  }
  public enum State {
    /// Loading, please wait
    public static func loading() -> String { Texts.tr("Strings", "state.loading", fallback: "Loading, please wait")
    }
  }
  public enum Tip {
    public enum Settings {
      /// Don't forget to check settings 🦥
      public static func message() -> String { Texts.tr("Strings", "tip.settings.message", fallback: "Don't forget to check settings 🦥")
      }
      /// Tip
      public static func title() -> String { Texts.tr("Strings", "tip.settings.title", fallback: "Tip")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Texts {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.main
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
// swiftlint:enable all
