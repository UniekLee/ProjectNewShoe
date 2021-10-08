import Foundation

class Formatter {
    private static let shared: Formatter = Formatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

extension Formatter {
    static var date: DateFormatter { Formatter.shared.dateFormatter }
}

extension Int {
    var asRoundedKM: Double { round((Double(self) / 10)) / 100 }
}
