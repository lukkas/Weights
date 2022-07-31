//
// Created by Łukasz Kasperek on 31/07/2022.
//

import Foundation
import Nimble
@testable import Services
import Quick

class PaceValueTransformerSpec: QuickSpec {
    override func spec() {
        describe("transformer") {
            var sut: PaceValueTransformer!
            beforeEach {
                sut = PaceValueTransformer()
            }
            context("when transorming values back and forth") {
                var pace: Pace!
                var transormedBackPace: Pace?
                beforeEach {
                    pace = Pace(components: [1, -1, 0, 5])
                    let transformed = sut.transformedValue(pace)
                    transormedBackPace = sut.reverseTransformedValue(transformed) as? Pace
                }
                it("will have same value") {
                    expect(transormedBackPace).to(equal(pace))
                }
            }
        }
    }
}
