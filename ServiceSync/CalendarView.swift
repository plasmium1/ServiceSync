//
//  CalendarView.swift
//  Test
//
//  Created by Solena Ornelas Pagnucci on 11/11/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date?
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter

    // Initialize the date formatter
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
    }

    var body: some View {
        VStack(spacing: 16) {
            // Display the current month and year
            Text(dateFormatter.string(from: Date()))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding()

            // Display the days of the week header
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day.prefix(1))
                        .frame(maxWidth: .infinity)
                        .padding([.top,.bottom], 15)
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            .background(Color(UIColor.systemGray6))

            // Display the days in the calendar grid
            let daysInMonth = daysInMonth(for: Date())
            let rows = daysInMonth.chunked(into: 7) // Split into weeks of 7 days

            ForEach(rows, id: \.self) { week in
                HStack(spacing: 12) {
                    ForEach(week, id: \.self) { day in
                        if let day = day {
                            // Display the day with a button-like interaction
                            Text("\(day)")
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(width: 40, height: 40)
                                .background(self.isSelected(day) ? Color.blue : Color.clear)
                                .foregroundColor(self.isSelected(day) ? Color.white : Color.primary)
                                .clipShape(Circle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(self.isSelected(day) ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .shadow(color: self.isSelected(day) ? Color.blue.opacity(0.3) : Color.clear, radius: 5)
                                .onTapGesture {
                                    self.selectedDate = self.calendar.date(from: DateComponents(year: self.calendar.component(.year, from: Date()), month: self.calendar.component(.month, from: Date()), day: day))
                                }
                        } else {
                            Text("") // Empty space for non-month days
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
//            HStack{
//                Text("Events")
//                
//            }
//            padding(.horizontal)
//            .background(Color(UIColor.systemBackground))
//            .cornerRadius(20)
//            .shadow(radius: 10)
//            Spacer()
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }

    // Function to get the days in a given month
    private func daysInMonth(for date: Date) -> [Int?] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstDayOfMonth = calendar.dateComponents([.weekday], from: startOfMonth).weekday!
        let days = range.compactMap { day -> Int? in
            return day
        }

        // Adjust the days to fit in the calendar grid
        var daysInCalendar: [Int?] = Array(repeating: nil, count: firstDayOfMonth - 1)
        daysInCalendar.append(contentsOf: days)
        return daysInCalendar + Array(repeating: nil, count: 42 - daysInCalendar.count)
    }

    private func isSelected(_ day: Int) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        let selectedComponents = calendar.dateComponents([.day, .month, .year], from: selectedDate)
        let selectedDay = selectedComponents.day
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        return selectedDay == day && selectedComponents.month == currentMonth && selectedComponents.year == currentYear
    }
}

extension Array {
    // Helper function to split an array into chunks of a specific size
    func chunked(into size: Int) -> [[Element]] {
        var chunked: [[Element]] = []
        
        for i in stride(from: 0, to: count, by: size) {
            let end = Swift.min(i + size, count)  // Ensure the end index is within bounds
            let chunk = Array(self[i..<end]) // Slice the array from i to end
            chunked.append(chunk)
        }
        
        return chunked
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
