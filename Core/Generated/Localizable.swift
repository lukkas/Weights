// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum ExerciseCreation {
    /// Add
    internal static let add = L10n.tr("Localizable", "exerciseCreation.add")
    internal enum LateralitySelector {
      /// Bilateral
      internal static let bilateral = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.bilateral")
      /// Unilateral separate
      internal static let unilateralSeparate = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralSeparate")
      /// Unilateral simultaneous
      internal static let unilateralSimultaneous = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralSimultaneous")
    }
    internal enum MetricSelector {
      /// Duration
      internal static let duration = L10n.tr("Localizable", "exerciseCreation.metricSelector.duration")
      /// Reps
      internal static let reps = L10n.tr("Localizable", "exerciseCreation.metricSelector.reps")
    }
    internal enum NameField {
      /// Name
      internal static let title = L10n.tr("Localizable", "exerciseCreation.nameField.title")
    }
  }

  internal enum ExercisesList {
    internal enum NavBar {
      /// Exercises
      internal static let exercises = L10n.tr("Localizable", "exercisesList.navBar.exercises")
      /// Home
      internal static let home = L10n.tr("Localizable", "exercisesList.navBar.home")
      /// Plan
      internal static let plan = L10n.tr("Localizable", "exercisesList.navBar.plan")
    }
  }

  internal enum Root {
    internal enum Tab {
      /// Exercises
      internal static let exercises = L10n.tr("Localizable", "root.tab.exercises")
      /// Home
      internal static let home = L10n.tr("Localizable", "root.tab.home")
      /// Plan
      internal static let plan = L10n.tr("Localizable", "root.tab.plan")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
