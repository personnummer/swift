import Personnummer
import SwiftUI

@main
struct PersonnummerExampleApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}

struct ContentView: View {
	@State private var input = "19900101-0017"
	@State private var allowCoordinationNumber = true
	@State private var allowInterimNumber = false

	private var result: Result<Personnummer, Error> {
		Result {
			try Personnummer.parse(input, options: .init(
				allowCoordinationNumber: allowCoordinationNumber,
				allowInterimNumber: allowInterimNumber
			))
		}
	}

	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Personnummer", text: $input)
						.keyboardType(.numbersAndPunctuation)
						.autocorrectionDisabled()
						.textInputAutocapitalization(.characters)
					Toggle("Allow coordination numbers", isOn: $allowCoordinationNumber)
					Toggle("Allow interim numbers", isOn: $allowInterimNumber)
				}

				switch result {
				case .success(let pnr):
					Section("Valid") {
						LabeledContent("Short format", value: pnr.format())
						LabeledContent("Long format", value: pnr.format(longFormat: true))
						LabeledContent("Date", value: pnr.getDate().formatted(
							Date.FormatStyle(date: .long, time: .omitted, timeZone: .gmt)))
						LabeledContent("Age", value: String(pnr.getAge()))
						LabeledContent("Sex", value: pnr.isMale() ? "Male" : "Female")
						LabeledContent("Coordination number", value: pnr.isCoordinationNumber() ? "Yes" : "No")
						LabeledContent("Interim number", value: pnr.isInterimNumber() ? "Yes" : "No")
					}
				case .failure(let error):
					Section("Invalid") {
						Text(String(describing: error))
							.foregroundStyle(.red)
					}
				}
			}
			.navigationTitle("Personnummer")
		}
	}
}

#Preview {
	ContentView()
}
