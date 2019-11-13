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
		XCTAssertTrue(Personnummer.isValid("510818-9167"));
		XCTAssertTrue(Personnummer.isValid("19900101-0017"));
		XCTAssertTrue(Personnummer.isValid("19130401+2931"));
		XCTAssertTrue(Personnummer.isValid("196408233234"));
		XCTAssertTrue(Personnummer.isValid("0001010107"));
		XCTAssertTrue(Personnummer.isValid("000101-0107"));
	}

	func testPersonnummerWithoutControlDigit() {
		XCTAssertFalse(Personnummer.isValid("510818-916"));
		XCTAssertFalse(Personnummer.isValid("19900101-001"));
		XCTAssertFalse(Personnummer.isValid("100101+001"));
	}

	func testPersonnummerWithWrongFormats() {
		XCTAssertFalse(Personnummer.isValid("112233-4455"));
		XCTAssertFalse(Personnummer.isValid("19112233-4455"));
		XCTAssertFalse(Personnummer.isValid("9999999999"));
		XCTAssertFalse(Personnummer.isValid("199999999999"));
		XCTAssertFalse(Personnummer.isValid("9913131315"));
		XCTAssertFalse(Personnummer.isValid("9911311232"));
		XCTAssertFalse(Personnummer.isValid("9902291237"));
		XCTAssertFalse(Personnummer.isValid("19990919_3766"));
		XCTAssertFalse(Personnummer.isValid("990919_3766"));
		XCTAssertFalse(Personnummer.isValid("199909193776"));
		XCTAssertFalse(Personnummer.isValid("Just a string"));
		XCTAssertFalse(Personnummer.isValid("990919+3776"));
		XCTAssertFalse(Personnummer.isValid("990919-3776"));
		XCTAssertFalse(Personnummer.isValid("9909193776"));
		XCTAssertFalse(Personnummer.isValid("000Ö01-0A07"));
		XCTAssertFalse(Personnummer.isValid("000ÖBB_01-AAA07"));
	}

	func testCoOrdinationNumbers() {
		XCTAssertTrue(Personnummer.isValid("701063-2391"));
		XCTAssertTrue(Personnummer.isValid("640883-3231"));
	}

	func testWrongCoOrdinationNumbers() {
		XCTAssertFalse(Personnummer.isValid("900161-0017"));
		XCTAssertFalse(Personnummer.isValid("640893-3231"));
		XCTAssertFalse(Personnummer.isValid("6408933231"));
		XCTAssertFalse(Personnummer.isValid("19640893-3231"));
		XCTAssertFalse(Personnummer.isValid("196408933231"));
	}

	func testFormat() {
		XCTAssertEqual("510818-9167", Personnummer.format("510818-9167"));
		XCTAssertEqual("900101-0017", Personnummer.format("19900101-0017"));
		XCTAssertEqual("130401+2931", Personnummer.format("19130401+2931"));
		XCTAssertEqual("640823-3234", Personnummer.format("196408233234"));
		XCTAssertEqual("000101-0107", Personnummer.format("0001010107"));
		XCTAssertEqual("000101-0107", Personnummer.format("000101-0107"));
		XCTAssertEqual("130401+2931", Personnummer.format("191304012931"));
		XCTAssertEqual("195108189167", Personnummer.format("510818-9167", longFormat: true));
		XCTAssertEqual("199001010017", Personnummer.format("19900101-0017", longFormat: true));
		XCTAssertEqual("191304012931", Personnummer.format("19130401+2931", longFormat: true));
		XCTAssertEqual("196408233234", Personnummer.format("196408233234", longFormat: true));
		XCTAssertEqual("200001010107", Personnummer.format("0001010107", longFormat: true));
		XCTAssertEqual("200001010107", Personnummer.format("000101-0107", longFormat: true));
		XCTAssertEqual("190001010107", Personnummer.format("000101+0107", longFormat: true));
	}
}
