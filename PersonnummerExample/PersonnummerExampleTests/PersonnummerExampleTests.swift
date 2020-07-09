//
//  PersonnummerExampleTests.swift
//  PersonnummerExampleTests
//
//  Created by Philip Fryklund on 17/Nov/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import XCTest
@testable import Personnummer

class PersonnummerExampleTests: XCTestCase {
	func testPersonnummerWithControlDigit() {
		XCTAssertTrue(Personnummer.isValid("8507099805"));
		XCTAssertTrue(Personnummer.isValid("198507099805"));
		XCTAssertTrue(Personnummer.isValid("198507099813"));
		XCTAssertTrue(Personnummer.isValid("850709-9813"));
		XCTAssertTrue(Personnummer.isValid("196411139808"));
	}

	func testPersonnummerWithoutControlDigit() {
		XCTAssertFalse(Personnummer.isValid("19850709980"));
		XCTAssertFalse(Personnummer.isValid("19850709981"));
		XCTAssertFalse(Personnummer.isValid("19641113980"));
	}

	func testPersonnummerWithWrongFormats() {
		XCTAssertFalse(Personnummer.isValid("112233-4455"));
		XCTAssertFalse(Personnummer.isValid("19112233-4455"));
		XCTAssertFalse(Personnummer.isValid("20112233-4455"));
		XCTAssertFalse(Personnummer.isValid("9999999999"));
		XCTAssertFalse(Personnummer.isValid("199999999999"));
		XCTAssertFalse(Personnummer.isValid("199909193776"))
		XCTAssertFalse(Personnummer.isValid("Just a string"));
		XCTAssertFalse(Personnummer.isValid("000Ö01-0A07"));
		XCTAssertFalse(Personnummer.isValid("000ÖBB_01-AAA07"));
		XCTAssertFalse(Personnummer.isValid("201509160006"))
	}

	func testCoOrdinationNumbers() {
		XCTAssertTrue(Personnummer.isValid("198507699802"));
		XCTAssertTrue(Personnummer.isValid("850769-9802"));
		XCTAssertTrue(Personnummer.isValid("198507699810"));
		XCTAssertTrue(Personnummer.isValid("850769-9810"));
	}

	func testWrongCoOrdinationNumbers() {
		XCTAssertFalse(Personnummer.isValid("198567099805"));
	}

	func testFormat() {
		XCTAssertEqual("850709-9805", Personnummer.format("19850709-9805"));
		XCTAssertEqual("850709-9813", Personnummer.format("198507099813"));
		XCTAssertEqual("198507099805", Personnummer.format("19850709-9805", longFormat: true));
		XCTAssertEqual("198507099813", Personnummer.format("198507099813", longFormat: true));
	}
}
