import SwiftUI

struct CalenderView: View {
    let days = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
    @State var selectedMonth = 0
    @State var selectedDate = Date()
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(spacing: 20) {
                //Month Selection
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            selectedMonth -= 1
                        }
                    } label: {
                        Image(systemName: "lessthan")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 26)
                    }
                    
                    Spacer()
                    Text(selectedDate.monthAndYear())
                        .font(.title2)
                    Spacer()
                    
                    Button {
                        withAnimation {
                            selectedMonth += 1
                        }
                    } label: {
                        Image(systemName: "greaterthan")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 26)
                    }
                    
                    Spacer()
                }
                
                //Days of the Week
                HStack {
                    Spacer()
                    ForEach(days, id:\.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .medium))
                        
                        Spacer()
                    }
                }
                
                //Days
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                    ForEach(fetchDates()) { value in
                        ZStack {
                            if value.day != -1 {
                                Button {
                                    print(value.date)
                                } label: {
                                    VStack {
                                        Text("\(value.day)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .foregroundColor(.green)
                                    }
                                }
                                
                            } else {
                                Text("")
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                }
                .padding()
                
                //Practices
                VStack {
                    //ForEach(fetchPracticesForDay())
                    //create a collection "calendar" in each user, each document title should be a date. depending on the user's selected date
                    //we fetch the practices completed and not completed
                    //daily we add a new document to that collection with all the user's practices and whether or not they have finished it in that day
                    //we simply retrieve that here in fetchPracticesForDay()
                }
            }
            .onChange(of: selectedMonth) { _ in
                selectedDate = fetchSelectedMonth()
            }
        }
    }
    
    
    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        
        var dates = currentMonth.datesOfMonth().map({CalendarDate(day: calendar.component(.day, from: $0), date: $0)})
        let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date())
        
        for _ in 0..<firstDayOfWeek - 1 {
            dates.insert(CalendarDate(day: -1, date: Date()), at: 0)
        }
        return dates
    }
    
    func fetchSelectedMonth() -> Date {
        let calendar = Calendar.current
        let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())
        return month!
    }
}

struct CalendarDate: Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}

extension Date {
    
    func monthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        return formatter.string(from: self)
    }
    
    func datesOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        endDateComponents.day = -1
        let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyy"
        return formatter.string(from: self)
    }
}
