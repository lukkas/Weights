//
//  WeightValueTransformer_tests.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import Foundation
import Nimble
@testable import Services
import Quick

class WeightValueTransformerSpec: QuickSpec {
    override func spec() {
        describe("transformer") {
            var sut: WeightValueTransformer!
            beforeEach {
                sut = WeightValueTransformer()
            }
            context("when transforming back and forth") {
                var weight: Weight!
                var transformedBackWeight: Any?
                context("kg weight") {
                    beforeEach {
                        weight = Weight(value: 5, unit: .kg)
                        let transformed = sut.transformedValue(weight)
                        transformedBackWeight = sut.reverseTransformedValue(transformed)
                    }
                    it("will get same value back") {
                        expect(transformedBackWeight as? Weight).to(equal(weight))
                    }
                }
                context("lbs weight") {
                    beforeEach {
                        weight = Weight(value: 10, unit: .lbs)
                        let transformed = sut.transformedValue(weight)
                        transformedBackWeight = sut.reverseTransformedValue(transformed)
                    }
                    it("will get same value back") {
                        expect(transformedBackWeight as? Weight).to(equal(weight))
                    }
                }
            }
        }
    }
}
