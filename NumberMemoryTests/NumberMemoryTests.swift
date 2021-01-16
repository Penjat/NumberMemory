//
//  NumberMemoryTests.swift
//  NumberMemoryTests
//
//  Created by Spencer Symington on 2020-11-16.
//  Copyright © 2020 Spencer Symington. All rights reserved.
//

import XCTest

class NumberMemoryTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testPeopleCount() {
		let numberTransformer = NumberTransformer()
		XCTAssertTrue(numberTransformer.people.count == 100)
    }

	func testActionCount() {
		let numberTransformer = NumberTransformer()
		XCTAssertTrue(numberTransformer.actions.count == 100)
	}

	func testCorrectPeople() {
		let numberTransformer = NumberTransformer()
		XCTAssertEqual(numberTransformer.toPerson(from: 44), "DOLLY PARTON")
		XCTAssertEqual(numberTransformer.toPerson(from: 73), "LOUIS C.K.")
		XCTAssertEqual(numberTransformer.toPerson(from: 04), "ODIN")
		XCTAssertEqual(numberTransformer.toPerson(from: 29), "BARNY GUMBLE")
		XCTAssertEqual(numberTransformer.toPerson(from: 09), "OWEN WILSON")
		XCTAssertEqual(numberTransformer.toPerson(from: 78), "LOUIS THOREUX")
	}

}
