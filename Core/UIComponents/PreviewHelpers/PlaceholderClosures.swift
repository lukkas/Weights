//
//  PlaceholderClosures.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/09/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

func placeholderClosure<T>() -> T { fatalError() }
func placeholderClosure<P, T>(arg1: P) ->  T { fatalError() }
