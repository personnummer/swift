//
//  Personnummer.swift
//  Personnummer
//
//  Created by Philip Fryklund on 17/Nov/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import Foundation






public struct Personnummer {
	
	public static func isValid(_ personnummer: String) -> Bool {
		return Personnummer(personnummer: personnummer) != nil
	}
	
	public static func format(_ personnummer: String, longFormat: Bool = false) -> String? {
		return Personnummer(personnummer: personnummer)?.format(longFormat: longFormat)
	}
	
		
	public enum Separator: Character {
		case youngerThan100 = "-"
		case olderThan100 = "+"
	}
	
	public let inputPersonnummer: String
	public let century: Int
	public let year: Int
	public let month: Int
	public let day: Int
	public let separator: Separator
	public let fourLast: Int
//	public let checkSum: Int
	
	
//	public var isValid: Bool {
////		let luhnString = "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%03i", num))\(checkSum)"
//		let luhnString = "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%04i", fourLast))"
//		var numbers = luhnString.reversed().map { Int(String($0))! }
//		for (i, number) in numbers.enumerated() where i % 2 == 1 {
//			let nr = number * 2
//			numbers[i] = nr >= 10 ? nr - 9 : nr
//		}
//
//		let sum = numbers.reduce(0, +)
//		print(inputPersonnummer, luhnString, sum, sum % 10)
//
//		return sum % 10 == 0
//	}
	
	public func format(longFormat: Bool = false) -> String {
		if longFormat {
//			return "\(String(format: "%02i", century))\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%03i", num))\(checkSum)"
			return "\(String(format: "%02i", century))\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%04i", fourLast))"
		}
		else {
//			return "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(separator.rawValue)\(String(format: "%03i", num))\(checkSum)"
			return "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(separator.rawValue)\(String(format: "%04i", fourLast))"
		}
	}
	
	
	
	public init?(personnummer: String) {
//		let regexPattern = "^(\\d{2}){0,1}(\\d{2})(\\d{2})(\\d{2})([\\+\\-\\s]?)(\\d{3})(\\d)$"
		let regexPattern = "^(\\d{2}){0,1}(\\d{2})(\\d{2})(\\d{2})([\\+\\-\\s]?)(\\d{4})$"
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
//		guard 	let checkSum: Int = Int(personnummer.substring(match.range(at: 7))) else { return nil}
		
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
		
//		let luhnString = "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%03i", num))\(checkSum)"
		let luhnString = "\(String(format: "%02i", year))\(String(format: "%02i", month))\(String(format: "%02i", day))\(String(format: "%04i", fourLast))"
		var numbers = luhnString.reversed().map { Int(String($0))! }
		for (i, number) in numbers.enumerated() where i % 2 == 1 {
			let nr = number * 2
			numbers[i] = nr >= 10 ? nr - 9 : nr
		}
		
		let sum = numbers.reduce(0, +)
//		print(inputPersonnummer, luhnString, sum, sum % 10)
		
		guard sum % 10 == 0 else {
			return nil
		}
		
		self.inputPersonnummer = personnummer
		self.century = century!
		self.year = year
		self.month = month
		self.day = day
		self.separator = separator!
		self.fourLast = fourLast
//		self.checkSum = checkSum
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
