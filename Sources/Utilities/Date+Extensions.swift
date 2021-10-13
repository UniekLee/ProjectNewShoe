import Foundation

extension Date {
    static func removingTime(from dateTime: Date) -> Date {
        guard let date = Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month, .day],
                from: dateTime
            )
        ) else {
            fatalError("Failed to remove time from Date object")
        }
        
        return date
    }
}
