// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
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
      /// Metric is how volume of exercise is measured.\nFor exercises with duration metric you'll be able to use Weights as timer indicating when your set is over.
      internal static let comment = L10n.tr("Localizable", "exerciseCreation.metricSelector.comment")
      /// Duration
      internal static let duration = L10n.tr("Localizable", "exerciseCreation.metricSelector.duration")
      /// Reps
      internal static let reps = L10n.tr("Localizable", "exerciseCreation.metricSelector.reps")
      /// Metric
      internal static let title = L10n.tr("Localizable", "exerciseCreation.metricSelector.title")
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
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
