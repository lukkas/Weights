// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// Localizable.strings
    ///   Weights
    /// 
    ///   Created by Łukasz Kasperek on 29/03/2020.
    ///   Copyright © 2020 Łukasz Kasperek. All rights reserved.
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// kg
    internal static let kg = L10n.tr("Localizable", "common.kg", fallback: "kg")
    /// meters
    internal static let meters = L10n.tr("Localizable", "common.meters", fallback: "meters")
    /// mins
    internal static let minutes = L10n.tr("Localizable", "common.minutes", fallback: "mins")
    /// reps
    internal static let reps = L10n.tr("Localizable", "common.reps", fallback: "reps")
  }
  internal enum ExerciseCreation {
    /// Add
    internal static let add = L10n.tr("Localizable", "exerciseCreation.add", fallback: "Add")
    /// Add Exercise
    internal static let title = L10n.tr("Localizable", "exerciseCreation.title", fallback: "Add Exercise")
    internal enum LateralitySelector {
      /// Bilateral
      internal static let bilateral = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.bilateral", fallback: "Bilateral")
      /// Laterality is about how work is distributed in any given exercise among left and right side of your body.
      /// * bilateral - left and right side work together i.e. bench press,
      /// * unilateral (both sides at once) - each side works individually, but on the same time i.e. dumbbell bench press,
      /// * unilateral (one side after another) - each body side works individually and you exercise second side of your body only after you finish first i.e. side plank.
      internal static let comment = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.comment", fallback: "Laterality is about how work is distributed in any given exercise among left and right side of your body.\n* bilateral - left and right side work together i.e. bench press,\n* unilateral (both sides at once) - each side works individually, but on the same time i.e. dumbbell bench press,\n* unilateral (one side after another) - each body side works individually and you exercise second side of your body only after you finish first i.e. side plank.")
      /// Laterality
      internal static let title = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.title", fallback: "Laterality")
      /// Unilateral (one side after another)
      internal static let unilateralIndividual = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralIndividual", fallback: "Unilateral (one side after another)")
      /// Unilateral (both sides at once)
      internal static let unilateralSingle = L10n.tr("Localizable", "exerciseCreation.lateralitySelector.unilateralSingle", fallback: "Unilateral (both sides at once)")
    }
    internal enum MetricSelector {
      /// Metric is how volume of exercise is measured.
      /// For exercises with duration metric you'll be able to use Weights as timer indicating when your set is over.
      internal static let comment = L10n.tr("Localizable", "exerciseCreation.metricSelector.comment", fallback: "Metric is how volume of exercise is measured.\nFor exercises with duration metric you'll be able to use Weights as timer indicating when your set is over.")
      /// Distance
      internal static let distance = L10n.tr("Localizable", "exerciseCreation.metricSelector.distance", fallback: "Distance")
      /// Duration
      internal static let duration = L10n.tr("Localizable", "exerciseCreation.metricSelector.duration", fallback: "Duration")
      /// Reps
      internal static let reps = L10n.tr("Localizable", "exerciseCreation.metricSelector.reps", fallback: "Reps")
      /// Metric
      internal static let title = L10n.tr("Localizable", "exerciseCreation.metricSelector.title", fallback: "Metric")
    }
    internal enum NameField {
      /// Exercise Name
      internal static let title = L10n.tr("Localizable", "exerciseCreation.nameField.title", fallback: "Exercise Name")
    }
  }
  internal enum ExercisePicker {
    internal enum NavBar {
      /// Add
      internal static let add = L10n.tr("Localizable", "exercisePicker.navBar.add", fallback: "Add")
      /// Pick exercises
      internal static let pickExercises = L10n.tr("Localizable", "exercisePicker.navBar.pickExercises", fallback: "Pick exercises")
    }
    internal enum PickedSection {
      /// Pick your first exercise
      internal static let emptyPlaceholder = L10n.tr("Localizable", "exercisePicker.pickedSection.emptyPlaceholder", fallback: "Pick your first exercise")
      /// Picked exercises
      internal static let title = L10n.tr("Localizable", "exercisePicker.pickedSection.title", fallback: "Picked exercises")
    }
  }
  internal enum ExercisesList {
    internal enum NavBar {
      /// Exercises
      internal static let exercises = L10n.tr("Localizable", "exercisesList.navBar.exercises", fallback: "Exercises")
      /// Home
      internal static let home = L10n.tr("Localizable", "exercisesList.navBar.home", fallback: "Home")
      /// Plan
      internal static let plan = L10n.tr("Localizable", "exercisesList.navBar.plan", fallback: "Plan")
    }
    internal enum Placeholder {
      /// Tap plus to add first exercise
      internal static let subtitle = L10n.tr("Localizable", "exercisesList.placeholder.subtitle", fallback: "Tap plus to add first exercise")
      /// No exercises yet
      internal static let title = L10n.tr("Localizable", "exercisesList.placeholder.title", fallback: "No exercises yet")
    }
  }
  internal enum Planner {
    /// Add training day
    internal static let addDay = L10n.tr("Localizable", "planner.addDay", fallback: "Add training day")
    /// Add exercise
    internal static let addExercise = L10n.tr("Localizable", "planner.addExercise", fallback: "Add exercise")
    /// Planner
    internal static let title = L10n.tr("Localizable", "planner.title", fallback: "Planner")
    internal enum BottomBar {
      internal enum WorkoutName {
        /// Workout name
        internal static let placeholder = L10n.tr("Localizable", "planner.bottomBar.workoutName.placeholder", fallback: "Workout name")
      }
    }
    internal enum Exercise {
      /// Add next...
      internal static let add = L10n.tr("Localizable", "planner.exercise.add", fallback: "Add next...")
    }
    internal enum NavigationBar {
      /// Save
      internal static let save = L10n.tr("Localizable", "planner.navigationBar.save", fallback: "Save")
    }
  }
  internal enum Plans {
    internal enum Collection {
      internal enum Placeholder {
        /// Tap plus to add your first plan
        internal static let subtitle = L10n.tr("Localizable", "plans.collection.placeholder.subtitle", fallback: "Tap plus to add your first plan")
        /// You haven't added any plans yet
        internal static let title = L10n.tr("Localizable", "plans.collection.placeholder.title", fallback: "You haven't added any plans yet")
      }
      internal enum SectionHeader {
        /// CURRENT PLAN
        internal static let currentPlan = L10n.tr("Localizable", "plans.collection.sectionHeader.currentPlan", fallback: "CURRENT PLAN")
        /// OTHER PLANS
        internal static let otherPlans = L10n.tr("Localizable", "plans.collection.sectionHeader.otherPlans", fallback: "OTHER PLANS")
      }
    }
    internal enum NavBar {
      /// Plan
      internal static let title = L10n.tr("Localizable", "plans.navBar.title", fallback: "Plan")
    }
  }
  internal enum Root {
    internal enum Tab {
      /// Exercises
      internal static let exercises = L10n.tr("Localizable", "root.tab.exercises", fallback: "Exercises")
      /// Home
      internal static let home = L10n.tr("Localizable", "root.tab.home", fallback: "Home")
      /// Plan
      internal static let plan = L10n.tr("Localizable", "root.tab.plan", fallback: "Plan")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
