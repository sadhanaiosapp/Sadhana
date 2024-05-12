import SwiftUI
import Firebase
import FirebaseFirestore

struct SettingsIndividualPractice: View {
    @State var dailyFreq: String = ""
    @State var mandalaDuration: String = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(settingsViewModel.practiceID)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            Text("You can edit the daily frequency or mandala duration of this practice")
                .font(.subheadline)
                .italic()
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            EditView(title: "Daily Frequency", value: settingsViewModel.frequency, editedValue: $dailyFreq)
            InfoView(title: "Lifetime Count", value: settingsViewModel.count)
            
            
            InfoView(title: "Current Mandala", value: settingsViewModel.mandalaCount)
            EditView(title: "Mandala Duration", value: settingsViewModel.mandalaDuration, editedValue: $mandalaDuration)
            InfoView(title: "Mandalas Completed", value: settingsViewModel.mandalasCompleted)
            
            
            Spacer()
            
            Button {
                if dailyFreq != "" || mandalaDuration != "" {
                    if dailyFreq == "" { dailyFreq = settingsViewModel.frequency }
                    if mandalaDuration == "" { mandalaDuration = settingsViewModel.mandalaDuration }
                    
                    let uid = UserDefaults.standard.string(forKey: "user")
                    
                    Task {
                        await settingsViewModel.updatePracticeInfo(uid: uid!, practice: settingsViewModel.practiceID, dF: dailyFreq, mD: mandalaDuration)
                    }
                }
                
                dismiss()
            } label: {
                BottomBlueButton(text: "DONE", image: "checkmark.circle", color: Color(.systemBlue), textColor: Color(.white))
            }
        }
    }
}

struct InfoView: View {
    var title: String
    var value: String
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .padding()
            
            Spacer()
            
            Text(value)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

struct EditView: View {
    var title: String
    var value: String
    @Binding var editedValue: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
                .font(.headline)
                .padding()
            
            Spacer()
            
            TextField(value, text: $editedValue)
                .frame(width: 30)
                .foregroundColor(.black)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}


