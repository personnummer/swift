# Personnummer [![Build Status](https://github.com/personnummer/swift/workflows/build/badge.svg)](https://github.com/personnummer/swift/actions)

Validate Swedish personal identity numbers.

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/personnummer/swift.git", from: "1.0.2")
```

### Cocoapods (Legacy)

**Note:** CocoaPods is no longer actively maintained for this package.
Swift Package Manager is the recommended installation method.

```ruby
pod 'Personnummer', '~> 1.0.0'
```

## Usage

```swift
// Validate
if !Personnummer.isValid(personnummerString) {
    fatalError("Personnummer \(personnummerString) was invalid")
}

// Validate and format
if let formattedPersonnummer = Personnummer.format(personnummerString) {
    print(formattedPersonnummer)
}

// Get components of valid personnummer such as year etc and format
guard let personnummer = Personnummer(personnummer: personnummerString) {
    fatalError("Personnummer \(personnummerString) was invalid")
}

print(personnummer.century)
print(personnummer.year)
print(personnummer.month)
print(personnummer.day)
print(personnummer.separator)
print(personnummer.fourLast)
```