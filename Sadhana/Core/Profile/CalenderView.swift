import SwiftUI
import Firebase
import FirebaseFirestore

struct CalenderView: View {
    let days = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]

    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(spacing: 20) {
                //Month Selection
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            calendarViewModel.selectedMonth -= 1
                            calendarViewModel.selectedDate = calendarViewModel.fetchSelectedMonth()
                            Task {
                                await calendarViewModel.fetchDates()
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 18)
                    }
                    
                    Spacer()
                    Text(calendarViewModel.selectedDate.monthAndYear())
                        .font(.title2)
                    Spacer()
                    
                    Button {
                        withAnimation {
                            calendarViewModel.selectedMonth += 1
                            calendarViewModel.selectedDate = calendarViewModel.fetchSelectedMonth()
                            Task {
                                await calendarViewModel.fetchDates()
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 18)
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
                    ForEach(calendarViewModel.dates, id: \.id) { value in
                        ZStack {
                            if value.day != -1 {
                                Button {
                                    calendarViewModel.selectedDate = value.date
                                    Task {
                                        await calendarViewModel.fetchPracticesForCalendarDate(user: user, selectedDate: calendarViewModel.selectedDate)
                                    }
                                    
                                } label: {
                                    if value.date == calendarViewModel.selectedDate {
                                        VStack {
                                            Text("\(value.day)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            
                                            Circle()
                                                .frame(width: 8, height: 8)
                                                .foregroundColor(value.color)
                                        }
                                        .frame(width: 28, height: 50)
                                        .background(Color(.systemBlue))
                                        .cornerRadius(10)
                                        
                                    } else {
                                        VStack {
                                            Text("\(value.day)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            
                                            Circle()
                                                .frame(width: 8, height: 8)
                                                .foregroundColor(value.color)
                                        }
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
                
                VStack {
                    if calendarViewModel.views.count == 0 {
                        CalendarItemView(id: "No practices to show for this date!", isFinished: false)
                    }
                    
                    else {
                        ForEach(calendarViewModel.views) { view in
                            CalendarItemView(id: view.id, isFinished: view.isFinished)
                        }
                    }
                }
            }
        }
    }
}

struct CalendarDate: Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
    var color: Color
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

extension Color {
    init(hex: String) {
        let color = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        
        Scanner(string: color).scanHexInt64(&rgb)
        
        self.init(red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                  green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: Double(rgb & 0x0000FF) / 255.0)
    }
}
