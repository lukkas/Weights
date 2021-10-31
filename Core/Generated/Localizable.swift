// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel")
    /// kg
    internal static let kg = L10n.tr("Localizable", "common.kg")
    /// mins
    internal static let minutes = L10n.tr("Localizable", "common.minutes")
    /// reps
    internal static let reps = L10n.tr("Localizable", "common.reps")
  }

  internal enum ExerciseCreation {
    /// Add
    internal static let add = L10n.tr("Localizable", "exerciseCreation.add")
    /// Add Exercise
    internal static let title = L10n.tr("Localizable", "exerciseCreation.title")
    internal enum LateralitySelector {
      /// Bilateral
      internal static let bilateral = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.bilateral")
      /// Laterality is about how work is distributed in any given exercise among left and right side of your body.
      /// * bilateral - left and right side work together i.e. bench press,
      /// * unilateral (both sides at once) - each side works individually, but on the same time i.e. dumbbell bench press,
      /// * unilateral (one side after another) - each body side works individually and you exercise second side of your body only after you finish first i.e. side plank.
      internal static let comment = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.comment")
      /// Laterality
      internal static let title = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.title")
      /// Unilateral (one side after another)
      internal static let unilateralIndividual = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralIndividual")
      /// Unilateral (both sides at once)
      internal static let unilateralSingle = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralSingle")
    }
    internal enum MetricSelector {
      /// Metric is how volume of exercise is measured.
      /// For exercises with duration metric you'll be able to use Weights as timer indicating when your set is over.
      internal static let comment = L10n.tr("Localizable", "exerciseCreation.metricSelector.comment")
      /// Duration
      internal static let duration = L10n.tr("Localizable", "exerciseCreation.metricSelector.duration")
      /// Reps
      internal static let reps = L10n.tr("Localizable", "exerciseCreation.metricSelector.reps")
      /// Metric
      internal static let title = L10n.tr("Localizable", "exerciseCreation.metricSelector.title")
    }
    internal enum NameField {
      /// Exercise Name
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
    internal enum Placeholder {
      /// Tap add to add first exercise
      internal static let subtitle = L10n.tr("Localizable", "exercisesList.placeholder.subtitle")
      /// No exercises yet
      internal static let title = L10n.tr("Localizable", "exercisesList.placeholder.title")
    }
  }

  internal enum Planner {
    /// Add training day
    internal static let addDay = L10n.tr("Localizable", "planner.addDay")
    /// Planner
    internal static let title = L10n.tr("Localizable", "planner.title")
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
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
