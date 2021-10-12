import Foundation

public class Formatter {
    private static let shared: Formatter = Formatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

public extension Formatter {
    static var date: DateFormatter { Formatter.shared.dateFormatter }
    static var time: DateFormatter { Formatter.shared.timeFormatter }
}

public extension Int {
    var asRoundedKM: Double { round((Double(self) / 10)) / 100 }
}
