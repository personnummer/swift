import Foundation

/// Thrown when a string is not a valid Swedish personal identity number.
public struct PersonnummerError: Error, CustomStringConvertible {
	public let description = "Invalid swedish personal identity number"
}

/**
	Parse, validate and format Swedish personal identity numbers (personnummer).

	Follows the personnummer package specification v3.1:
	https://github.com/personnummer/meta#package-specification-v31

	```
	let pnr = try Personnummer.parse("19900101-0017")
	pnr.format()              // "900101-0017"
	pnr.format(longFormat: true) // "199001010017"

	Personnummer.valid("19900101-0017") // true
	```
*/
public struct Personnummer {

	public struct Options {
		public var allowCoordinationNumber: Bool
		public var allowInterimNumber: Bool

		public init(allowCoordinationNumber: Bool = true, allowInterimNumber: Bool = false) {
			self.allowCoordinationNumber = allowCoordinationNumber
			self.allowInterimNumber = allowInterimNumber
		}
	}

	public let century: String
	public let fullYear: String
	public let year: String
	public let month: String
	public let day: String
	/// `-` or `+` (person is 100 years or older).
	public let sep: String
	/// The three digits after the birth date, starting with a letter for interim numbers.
	public let num: String
	public let check: String

	private static let interimLetters = "TRSUWXJKLMN"
	private static let regex = try! NSRegularExpression(
		pattern: "^(\\d{2})?(\\d{2})(\\d{2})(\\d{2})([+-]?)((?!000)\\d{3}|[\(interimLetters)]\\d{2})(\\d)$"
	)
	private static let calendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "UTC")!
		return calendar
	}()

	public init(_ ssn: String, options: Options = Options()) throws {
		guard let match = Self.regex.firstMatch(in: ssn, range: NSRange(ssn.startIndex..., in: ssn)) else {
			throw PersonnummerError()
		}
		func group(_ i: Int) -> String? {
			Range(match.range(at: i), in: ssn).map { String(ssn[$0]) }
		}

		year = group(2)!
		month = group(3)!
		day = group(4)!
		num = group(6)!
		check = group(7)!

		let currentYear = Self.calendar.component(.year, from: Date())
		if let century = group(1) {
			self.century = century
			sep = currentYear - Int(century + year)! < 100 ? "-" : "+"
		} else {
			sep = group(5) == "+" ? "+" : "-"
			let baseYear = sep == "+" ? currentYear - 100 : currentYear
			century = String(String(baseYear - (baseYear - Int(year)!) % 100).prefix(2))
		}
		fullYear = century + year

		let luhnInput = year + month + day + num.replacingOccurrences(
			of: "[\(Self.interimLetters)]", with: "1", options: .regularExpression)
		guard Self.luhn(luhnInput) == Int(check)!,
			Self.isValidDate(fullYear, month, day) || isCoordinationNumber() else {
			throw PersonnummerError()
		}
		if !options.allowCoordinationNumber && isCoordinationNumber() {
			throw PersonnummerError()
		}
		if !options.allowInterimNumber && isInterimNumber() {
			throw PersonnummerError()
		}
	}

	public static func parse(_ ssn: String, options: Options = Options()) throws -> Personnummer {
		try Personnummer(ssn, options: options)
	}

	public static func valid(_ ssn: String, options: Options = Options()) -> Bool {
		(try? parse(ssn, options: options)) != nil
	}

	/// Long format is `YYYYMMDDXXXX`, short format is `YYMMDD-XXXX` (or `+` for 100 years or older).
	public func format(longFormat: Bool = false) -> String {
		longFormat
			? century + year + month + day + num + check
			: year + month + day + sep + num + check
	}

	/// Birth date at midnight UTC. For coordination numbers 60 is removed from the day.
	public func getDate() -> Date {
		Self.calendar.date(from: DateComponents(
			year: Int(fullYear),
			month: Int(month),
			day: Int(day)! - (isCoordinationNumber() ? 60 : 0)
		))!
	}

	public func getAge() -> Int {
		Self.calendar.dateComponents([.year], from: getDate(), to: Date()).year!
	}

	public func isCoordinationNumber() -> Bool {
		Self.isValidDate(fullYear, month, String(Int(day)! - 60))
	}

	public func isInterimNumber() -> Bool {
		Self.interimLetters.contains(num.first!)
	}

	public func isMale() -> Bool {
		Int(String(num.last!))! % 2 == 1
	}

	public func isFemale() -> Bool {
		!isMale()
	}

	private static func isValidDate(_ year: String, _ month: String, _ day: String) -> Bool {
		DateComponents(year: Int(year), month: Int(month), day: Int(day)).isValidDate(in: calendar)
	}

	/// Returns the check digit for `digits`.
	private static func luhn(_ digits: String) -> Int {
		var sum = 0
		for (i, c) in digits.enumerated() {
			var v = c.wholeNumberValue! * (2 - i % 2)
			if v > 9 { v -= 9 }
			sum += v
		}
		return (10 - sum % 10) % 10
	}
}
