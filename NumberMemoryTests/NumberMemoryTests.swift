//
//  NumberMemoryTests.swift
//  NumberMemoryTests
//
//  Created by Spencer Symington on 2020-11-16.
//  Copyright © 2020 Spencer Symington. All rights reserved.
//

import XCTest

@testable import NumberMemory


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

	func testDigitNumberValue1234() {
		/// Given
		let digitNumber = DigitNumber(digits: [1,2,3,4])
		let expecting = 1234
		XCTAssertEqual(digitNumber.numberValue, expecting)
	}

	func testDigitNumberValue624() {
		/// Given
		let digitNumber = DigitNumber(digits: [6,2,4])
		let expecting = 624
		XCTAssertEqual(digitNumber.numberValue, expecting)
	}

	func testDigitNumberValue1() {
		/// Given
		let digitNumber = DigitNumber(digits: [1])
		let expecting = 1
		XCTAssertEqual(digitNumber.numberValue, expecting)
	}

	func testNumberTransformerDigits() {
		let transformer = NumberTransformer()

		let output1 = transformer.transform(number: DigitNumber(digits: [1,2,3,4])).phraseString
		let expected1 = "ALI BABA coke under mask"
		XCTAssertEqual(output1, expected1)

		let output2 = transformer.transform(number: DigitNumber(digits: [3,5])).phraseString
		let expected2 = "CLINT EASTWOON"
		XCTAssertEqual(output2, expected2)

		let output3 = transformer.transform(number: DigitNumber(digits: [1,6,3,2,1])).phraseString
		let expected3 = "PIGGY twirling nun chucks DILDO"
		XCTAssertEqual(output3, expected3)

		let output4 = transformer.transform(number: DigitNumber(digits: [1,1,1,1])).phraseString
		let expected4 = "ALAN ALDA performing surgery"
		XCTAssertEqual(output4, expected4)

		let output5 = transformer.transform(number: DigitNumber(digits: [0,0,0,0])).phraseString
		let expected5 = "OLIVE OIL eating spinach"
		XCTAssertEqual(output5, expected5)

		let output6 = transformer.transform(number: DigitNumber(digits: [0,7])).phraseString
		let expected6 = "OL DIRTY BASTARD"
		XCTAssertEqual(output6, expected6)

		let output7 = transformer.transform(number: DigitNumber(digits: [0,0,0])).phraseString
		let expected7 = "OLIVE OIL SUN"
		XCTAssertEqual(output7, expected7)

		let output8 = transformer.transform(number: DigitNumber(digits: [0,1,0,0,1,2,3,4,5,6])).phraseString
		let expected8 = "PROFFESOR OAK eating spinach ALI BABA coke under mask ED SHEREN"
		XCTAssertEqual(output8, expected8)
	}
}
