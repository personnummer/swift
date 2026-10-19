# Personnummer [![Build Status](https://github.com/personnummer/swift/workflows/build/badge.svg)](https://github.com/personnummer/swift/actions)

Validate Swedish personal identity numbers.

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/personnummer/swift.git", from: "3.0.0")
```

### Cocoapods (Legacy)

**Note:** CocoaPods is no longer actively maintained for this package.
Swift Package Manager is the recommended installation method.

```ruby
pod 'Personnummer', '~> 3.0.0'
```

## Usage

Follows [package specification v3.1](https://github.com/personnummer/meta#package-specification-v31).

```swift
import Personnummer

// Validate
Personnummer.valid("19900101-0017") // true

// Parse, throws PersonnummerError if invalid
let pnr = try Personnummer.parse("19900101-0017")

pnr.format()                 // "900101-0017"
pnr.format(longFormat: true) // "199001010017"
pnr.getAge()
pnr.getDate()
pnr.isMale()
pnr.isFemale()
pnr.isCoordinationNumber()
pnr.isInterimNumber()

print(pnr.century, pnr.fullYear, pnr.year, pnr.month, pnr.day, pnr.sep, pnr.num, pnr.check)
```

### Options

```swift
let options = Personnummer.Options(
    allowCoordinationNumber: true, // default true
    allowInterimNumber: true       // default false
)

Personnummer.valid("000101-T220", options: options) // true
```

### Upgrading from 1.x

Version 3 is not compatible with 1.x:

- `Personnummer(personnummer:)` returning `nil` is replaced by `Personnummer.parse(_:)` / `Personnummer(_:)` which throw `PersonnummerError`.
- `Personnummer.isValid(_:)` is renamed to `Personnummer.valid(_:)`.
- The static `Personnummer.format(_:longFormat:)` is removed, use `try Personnummer.parse(s).format()`.
- Components are strings: `separator` is now `sep`, `fourLast` is split into `num` and `check`.

## Example app

`PersonnummerExample/PersonnummerExample.xcodeproj` is a SwiftUI app that uses the package from this repository. Open it in Xcode and run it in a simulator.

## In memoriam

Fredrik "Frozzare" Forsmo (1991-2026) was the initiator, co-founder and a core contributor of the personnummer project. This library carries his work. He is missed.
