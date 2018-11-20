# Personnummer swift

Small library to validate and format swedish social security numbers called "Personnummer".

## Installation 

### Cocoapods
	
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