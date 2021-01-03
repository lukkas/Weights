//
//  Metatypes.swift
//  Core
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG
var metaUITapGestureRecognizer: UITapGestureRecognizer.Type = UITapGestureRecognizer.self
var metaUIPanGestureRecognizer: UIPanGestureRecognizer.Type = UIPanGestureRecognizer.self
var metaUISelectionFeedbackGenerator: UISelectionFeedbackGenerator.Type = UISelectionFeedbackGenerator.self
var metaUIImpactFeedbackGenerator: UIImpactFeedbackGenerator.Type = UIImpactFeedbackGenerator.self
var metaUINotificationFeedbackGenerator: UINotificationFeedbackGenerator.Type = UINotificationFeedbackGenerator.self
#else
let metaUITapGestureRecognizer: UITapGestureRecognizer.Type = UITapGestureRecognizer.self
let metaUIPanGestureRecognizer: UIPanGestureRecognizer.Type = UIPanGestureRecognizer.self
let metaUISelectionFeedbackGenerator: UISelectionFeedbackGenerator.Type = UISelectionFeedbackGenerator.self
let metaUIImpactFeedbackGenerator: UIImpactFeedbackGenerator.Type = UIImpactFeedbackGenerator.self
let metaUINotificationFeedbackGenerator: UINotificationFeedbackGenerator.Type = UINotificationFeedbackGenerator.self
#endif
