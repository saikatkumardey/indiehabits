//
//  AddHabitSheet.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

struct AddHabit: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var newHabitTitle: String
    @Binding var newHabitStartDate: Date
    @Binding var newHabitReminderTime: Date
    @Binding var newHabitReminderEnabled: Bool
    @FocusState private var isTextFieldFocused: Bool
    @State private var formattedReminderTime: String
    
    let onAdd: () -> Void
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(newHabitTitle: Binding<String>, newHabitStartDate: Binding<Date>, newHabitReminderTime: Binding<Date>, newHabitReminderEnabled: Binding<Bool>, onAdd: @escaping () -> Void) {
        self._newHabitTitle = newHabitTitle
        self._newHabitStartDate = newHabitStartDate
        self._newHabitReminderTime = newHabitReminderTime
        self._newHabitReminderEnabled = newHabitReminderEnabled
        self._formattedReminderTime = State(initialValue: timeFormatter.string(from: newHabitReminderTime.wrappedValue))
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment:.center,spacing: 30) {
                HStack {
                    Text("I will")
                    Spacer()
                }
                TextField("Exercise for 10 mins every day", text: $newHabitTitle)
                    .focused($isTextFieldFocused)
                    .font(.system(size: 20))
                //                    .foregroundColor(.accentColor)
                HStack{
                    Text("every day")
                    Spacer()
                }
                DatePicker("starting from", selection: $newHabitStartDate, displayedComponents: .date)
                    .datePickerStyle(.automatic)
                ReminderConfigurationView(reminderTime: $newHabitReminderTime, isReminderEnabled: $newHabitReminderEnabled)
            }
            .padding(20)
            .navigationBarTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Create") {
                onAdd()
                dismiss()
            }.disabled(newHabitTitle.isEmpty))
            .task {
                isTextFieldFocused = true
            }
        }.environment(\.font, .system(size:30, weight: .light, design: .rounded))
    }
}

struct AddHabitSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit(newHabitTitle: .constant(""), newHabitStartDate: .constant(Date()), newHabitReminderTime: .constant(Date().startOfDay.addingTimeInterval(10*60*60)), newHabitReminderEnabled: .constant(false)) {
        }
    }
}
