//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct HabitRow: View {
    @EnvironmentObject var habitStore: HabitStore
    @ObservedObject var habit: Habit
    @State private var isAddHabitSheetPresented = false
    @State private var lastNdays = [Int]()
    
    var body: some View {
        ZStack(alignment: .topLeading){
            HStack {
                VStack(alignment: .leading,spacing: 5) {
                    HStack(alignment: .top) {
                        Text(habit.title)
                            .font(.system(size: 18))
                            .fontDesign(.rounded)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text(habit.reminderTime.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top,5)
                    
                    HStack{
                        ForEach(0..<lastNdays.count, id: \.self) { index in
                            let cell = lastNdays[index]
                            if cell == 1 {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        Spacer()
                        Spacer()
                    }
                    .padding(.vertical,10)
                    .onAppear(perform: {
                        lastNdays = habit.lastNdayCells(n: 7)
                    })
                    .onChange(of: habit.completedDates, perform: { value in
                        lastNdays = habit.lastNdayCells(n: 7)
                    })
                }.padding(.top,10)
                
                Spacer()
                
            }
        }
    }
    
}


struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habit: Habit(title: "Drink water", completedDates: [], startDate: Date(), reminderTime: Date(), isReminderEnabled: false))
            .padding(5)
    }
}
