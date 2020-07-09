//
//  Personnummer.swift
//  Personnummer
//
//  Created by Philip Fryklund on 17/Nov/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Foundation






/**
	`Personnummer` model to validate and format a personnummer

	Contains an initialized to get access to the components of a valid personnummer and convenient functions to just validate or reformat a personnummer.

	# Usage
	```
	guard let p = Personummer(personnummer: inputPersonnummer) else {
		fatalError("The personnummer input was incorrect")
	}
	```

	### Or

	```
	if !Personnummer.isValid(inputPersonnummer) {
		fatalError("The personnummer input was incorrect")
	}
	```
*/
public struct Personnummer {
	
	/**
		Convenient function to check if a personnummer is valid
	
		- Parameter personnummer: The personnummer to be validated.
		- Returns: Returns `true` if `personnummer` is valid and `false` if invalid.
	*/
	public static func isValid(_ personnummer: String) -> Bool {
		return Personnummer(personnummer: personnummer) != nil
	}
	
	/**
		Convenience method to format a valid personnummer
	
		- Parameter personnummer: The personnummer to be formatted.
		- Parameter longFormat: Long format is `yyyymmddnnnn`, short format is `yymmdd(+ or -)nnnn`.
		- Returns: Returns the formatted personnummer if `personnummer` was valid, otherwise returns `nil`.
	*/
	public static func format(_ personnummer: String, longFormat: Bool = false) -> String? {
		return Personnummer(personnummer: personnummer)?.format(longFormat: longFormat)
	}
	
	
	/// Separator between birth date and last four digits
	public enum Separator: Character {
		/// Person is younger than 100 years old
		case youngerThan100 = "-"
		/// Person is older than 100 years old
		case olderThan100 = "+"
	}
	
	/// The string used to initialize `Self`.
	public let inputPersonnummer: String
	/// The birth century Example: 1995, century = 19.
	public let century: Int
	/// The birth year of the century Example: 1995, year = 95.
	public let year: Int
	/// The birth month Example: 9.
	public let month: Int
	/// The birth day Example: 12.
	public let day: Int
	/// The separator indicating wether the person is older than 100 or not (+ or -).
	public let separator: Separator
	/// The last four digits.
	public let fourLast: Int
	
	
	
	/**
		Method to format a valid personnummer
	
		- Parameter personnummer: The personnummer to be formatted.
		- Parameter longFormat: Long format is `yyyymmddnnnn`, short format is `yymmdd(+ or -)nnnn`.
		- Returns: Returns the formatted personnummer.
	*/
	public func format(longFormat: Bool = false) -> String {
		if longFormat {
			return "\(String(format: "%02i", century))\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%04i", fourLast))"
		}
		else {
			return "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(separator.rawValue)\(String(format: "%04i", fourLast))"
		}
	}
	
	
	/**
		Try to initialize a new `Personnummer` model.
	
		Checks if `personnummer` is correctly formatted, is an actual date, conforms to Luhn Algorithm.
	
		- Parameter personnummer: The personnummer to be used to initialize.
		- Returns: Returns ´Personnummer´ if `personnummer` is valid and ´nil´ if invalid.
	*/
	public init?(personnummer: String) {
		let regexPattern = "^(\\d{2}){0,1}(\\d{2})(\\d{2})(\\d{2})([\\+\\-\\s]?)((?!000)\\d{4})$"
		let regexer = try! NSRegularExpression.init(pattern: regexPattern, options: [.anchorsMatchLines])
		guard let match = regexer.firstMatch(in: personnummer, options: [], range: NSRange(of: personnummer)) else {
			return nil
		}
		
				var century: Int? = Int(personnummer.substring(match.range(at: 1)))
		guard 	let year: Int = Int(personnummer.substring(match.range(at: 2))) else { return nil}
		guard 	let month: Int = Int(personnummer.substring(match.range(at: 3))) else { return nil}
		guard 	let day: Int = Int(personnummer.substring(match.range(at: 4))) else { return nil}
				var separator: Separator? = Separator(rawValue: personnummer.substring(match.range(at: 5)).first ?? "?")
		guard	let fourLast: Int = Int(personnummer.substring(match.range(at: 6))) else { return nil }
		
		if separator == nil {
			if century == nil || Int(Date().format("yyyy"))! - Int("\(century!)\(year)")! < 100 {
				separator = .youngerThan100
			}
			else {
				separator = .olderThan100
			}
		}
		
		if century == nil {
			let baseYear: Int
			switch separator! {
			case .youngerThan100: baseYear = Int(Date().format("yyyy"))!
			case .olderThan100:
				guard let d = Calendar.init(identifier: .gregorian).date(byAdding: .year, value: -100, to: Date()) else { return nil }
				baseYear = Int(d.format("yyyy"))!
			}
			century = (baseYear - ((baseYear - year) % 100)) / 100
		}
		
		var dateComponents = DateComponents()
		dateComponents.year = century! * 100 + year
		dateComponents.month = month
		dateComponents.day = day > 60 ? day - 60 : day
		guard dateComponents.isValidDate(in: Calendar.init(identifier: .gregorian)) else {
			return nil
		}
		
		let luhnString = "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%04i", fourLast))"
		var numbers = luhnString.reversed().map { Int(String($0))! }
		for (i, number) in numbers.enumerated() where i % 2 == 1 {
			let nr = number * 2
			numbers[i] = nr >= 10 ? nr - 9 : nr
		}
		
		guard numbers.reduce(0, +) % 10 == 0 else {
			return nil
		}
		
		self.inputPersonnummer = personnummer
		self.century = century!
		self.year = year
		self.month = month
		self.day = day
		self.separator = separator!
		self.fourLast = fourLast
	}
}










private extension String {
	
	func substring(_ range: NSRange) -> Substring {
		let location = range.location > self.utf16.count ? 0 : range.location
		let startIndex = self.index(self.startIndex, offsetBy: location)
		let endIndex = self.index(self.startIndex, offsetBy: location + range.length)
		return self[startIndex..<endIndex]
	}
}

private extension NSRange {
	
	init(of string: String) {
		self.init(location: 0, length: string.utf16.count)
	}
}

private extension Date {
	
	func format(_ format: String) -> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "sv_SE")
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}
