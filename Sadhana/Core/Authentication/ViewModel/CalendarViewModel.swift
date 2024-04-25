import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedMonth = 0
    @Published var selectedDate = Date()
    @Published var views: [CalendarItemView] = []
    @Published var dates: [CalendarDate] = []
    
    init() {
        Task {
            self.dates = await fetchDates()
        }
    }
    
    func fetchPracticesForCalendarDate(user: User, selectedDate: Date) async {
        var calendarDatePractices: [CalendarItemView] = []
        let dateString = selectedDate.string().replacingOccurrences(of: "/", with: ".")
        
        let snapshot = try? await Firestore.firestore().collection("users").document(user.id)
            .collection("calendar").document(dateString).getDocument()
        
        if let document = snapshot {
            if document.exists {
                let data = document.data()
                for (key, value) in data! {
                    let practiceIsFinished = CalendarItemView(id: key, isFinished: value as! Bool)
                    calendarDatePractices.append(practiceIsFinished)
                }
            }
        }
        
        views = calendarDatePractices
    }
    
    func fetchDates() async -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        let documentName = selectedDate.monthAndYear()
        let user = UserDefaults.standard.string(forKey: "user")
        var dictionary: [String: String] = [:]
        
        if let snapshot = try? await Firestore.firestore().collection("users").document(user!)
            .collection("dots").document(documentName).getDocument() {

            if let data = snapshot.data() {
                for (key, value) in data {
                    dictionary[key] = value as? String
                }
            }
        } else {
            print("Error fetching document")
        }

        var dates = [CalendarDate]()
        for dateOfMonth in currentMonth.datesOfMonth() {
            let day = calendar.component(.day, from: dateOfMonth)
            let dataFieldName = dateOfMonth.string().replacingOccurrences(of: "/", with: ".")

            if let color = dictionary[dataFieldName] {
                let calendarDate = CalendarDate(day: day, date: dateOfMonth, color: Color(hex: color))
                dates.append(calendarDate)
            } else {
                let calendarDate = CalendarDate(day: day, date: dateOfMonth, color: .gray)
                dates.append(calendarDate)
            }
            
            
        }
        let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date())
        
        for _ in 0..<firstDayOfWeek - 1 {
            dates.insert(CalendarDate(day: -1, date: Date(), color: .red), at: 0)
        }
        return dates
    }
    
    func fetchSelectedMonth() -> Date {
        let calendar = Calendar.current
        let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())
        return month!
    }
}
