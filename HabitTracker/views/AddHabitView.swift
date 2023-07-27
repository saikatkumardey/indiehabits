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
            VStack(alignment:.leading, spacing: 20) {
                TextField("What do you want to get better at?", text: $newHabitTitle, axis: .vertical)
                    .lineLimit(2)
                    .focused($isTextFieldFocused)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .fontWeight(.light)
                DateSelectionView(title: "Starting",selectedDate: $newHabitStartDate)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                ReminderConfigurationView(reminderTime: $newHabitReminderTime, isReminderEnabled: $newHabitReminderEnabled, title: "Remind me")
                    .font(.system(size: 20, weight: .light, design: .rounded))
            }
            .padding()
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
            
        }
        .gesture(TapGesture().onEnded{
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
    }
}

struct AddHabitSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit(newHabitTitle: .constant(""), newHabitStartDate: .constant(Date()), newHabitReminderTime: .constant(Date().startOfDay.addingTimeInterval(10*60*60)), newHabitReminderEnabled: .constant(false)) {
        }
    }
}
