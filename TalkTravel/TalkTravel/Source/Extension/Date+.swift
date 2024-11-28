import Foundation

extension Date {
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func getNextDateString(value: Int) -> String {
        let tomorrow = Calendar.current.date(byAdding: .day,
                                             value: value,
                                             to: self) ?? self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: tomorrow)
    }
}
