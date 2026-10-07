import XCTest
@testable import Personnummer

private struct TestItem: Decodable {
	let integer: Int
	let long_format: String
	let short_format: String
	let separated_format: String
	let separated_long: String
	let valid: Bool
	let type: String
	let isMale: Bool
	let isFemale: Bool

	/// All input formats except `short_format`, which has an ambiguous century.
	var inputs: [String] { [String(integer), long_format, separated_format, separated_long] }
}

private func loadTestdata(_ name: String) throws -> [TestItem] {
	let url = URL(string: "https://raw.githubusercontent.com/personnummer/meta/HEAD/testdata/\(name).json")!
	return try JSONDecoder().decode([TestItem].self, from: Data(contentsOf: url))
}

class PersonnummerExampleTests: XCTestCase {
	private static var list: [TestItem] = []
	private static var interim: [TestItem] = []

	override class func setUp() {
		list = (try? loadTestdata("list")) ?? []
		interim = (try? loadTestdata("interim")) ?? []
	}

	override func setUpWithError() throws {
		XCTAssertFalse(Self.list.isEmpty, "could not load testdata")
		XCTAssertFalse(Self.interim.isEmpty, "could not load testdata")
	}

	func testValid() {
		for item in Self.list {
			for input in item.inputs + [item.short_format] {
				XCTAssertEqual(item.valid, Personnummer.valid(input), input)
			}
		}
	}

	func testParseThrows() {
		for item in Self.list where !item.valid {
			for input in item.inputs {
				XCTAssertThrowsError(try Personnummer.parse(input), input) {
					XCTAssertTrue($0 is PersonnummerError)
				}
			}
		}
	}

	func testFormat() throws {
		for item in Self.list where item.valid {
			for input in item.inputs {
				let p = try Personnummer.parse(input)
				XCTAssertEqual(item.separated_format, p.format(), input)
				XCTAssertEqual(item.long_format, p.format(longFormat: true), input)
			}
		}
	}

	func testSex() throws {
		for item in Self.list where item.valid {
			for input in item.inputs + [item.short_format] {
				let p = try Personnummer.parse(input)
				XCTAssertEqual(item.isMale, p.isMale(), input)
				XCTAssertEqual(item.isFemale, p.isFemale(), input)
			}
		}
	}

	func testDateAndAge() throws {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "UTC")!
		for item in Self.list where item.valid {
			let s = item.long_format
			let day = Int(s.dropFirst(6).prefix(2))! - (item.type == "con" ? 60 : 0)
			let date = calendar.date(from: DateComponents(
				year: Int(s.prefix(4)), month: Int(s.dropFirst(4).prefix(2)), day: day))!
			let age = calendar.dateComponents([.year], from: date, to: Date()).year!

			for input in item.inputs {
				let p = try Personnummer.parse(input)
				XCTAssertEqual(item.type == "con", p.isCoordinationNumber(), input)
				XCTAssertEqual(date, p.getDate(), input)
				XCTAssertEqual(age, p.getAge(), input)
			}
		}
	}

	func testCoordinationNumberOption() {
		for item in Self.list where item.valid && item.type == "con" {
			XCTAssertFalse(Personnummer.valid(item.long_format, options: .init(allowCoordinationNumber: false)))
		}
	}

	func testInterimNumbers() throws {
		let options = Personnummer.Options(allowInterimNumber: true)
		for item in Self.interim {
			for input in [item.long_format, item.short_format, item.separated_format, item.separated_long] {
				XCTAssertFalse(Personnummer.valid(input), input)
				guard item.valid else {
					XCTAssertFalse(Personnummer.valid(input, options: options), input)
					continue
				}
				let p = try Personnummer.parse(input, options: options)
				XCTAssertTrue(p.isInterimNumber(), input)
				XCTAssertEqual(item.separated_format, p.format(), input)
				XCTAssertEqual(item.long_format, p.format(longFormat: true), input)
			}
		}
	}
}
