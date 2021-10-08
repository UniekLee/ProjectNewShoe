import Foundation

public class Formatter {
    private static let shared: Formatter = Formatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

public extension Formatter {
    static var date: DateFormatter { Formatter.shared.dateFormatter }
}

public extension Int {
    var asRoundedKM: Double { round((Double(self) / 10)) / 100 }
}
