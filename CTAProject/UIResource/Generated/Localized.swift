// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum L10n {
  /// 文字数が50文字を超過しています。
  public static let charactersExceeds50 = L10n.tr("Localizable", "CharactersExceeds50")
  /// グルスポ
  public static let gourmentSpot = L10n.tr("Localizable", "GourmentSpot")
  /// キーワード
  public static let keyWord = L10n.tr("Localizable", "KeyWord")
  /// リスト
  public static let list = L10n.tr("Localizable", "List")
  /// ローカライズサンプル
  public static let localizeSample = L10n.tr("Localizable", "LocalizeSample")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
