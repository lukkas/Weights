//
//  Pace_tests.swift
//  Core
//
//  Created by Łukasz Kasperek on 22/05/2022.
//

@testable import Core
import Nimble
import Quick

class PaceSpec: QuickSpec {
    override func spec() {
        describe("Pace.Component") {
            var component: Pace.Component?
            context("when initialized with 0 string") {
                beforeEach {
                    component = Pace.Component(textRepresentation: "0")
                }
                it("will initialize") {
                    expect(component).to(equal(.number(0)))
                }
            }
            context("when initialized with 9 string") {
                beforeEach {
                    component = Pace.Component(textRepresentation: "9")
                }
                it("will initialize") {
                    expect(component).to(equal(.number(9)))
                }
            }
            context("when initialized with two digit number string") {
                beforeEach {
                    component = Pace.Component(textRepresentation: "10")
                }
                it("won't intitialize") {
                    expect(component).to(beNil())
                }
            }
            context("when initialized with X") {
                beforeEach {
                    component = Pace.Component(textRepresentation: "X")
                }
                it("will intitialize") {
                    expect(component).to(equal(.explosive))
                }
            }
            context("when initialized with random character") {
                beforeEach {
                    component = Pace.Component(textRepresentation: "R")
                }
                it("won't intitialize") {
                    expect(component).to(beNil())
                }
            }
        }
    }
}
