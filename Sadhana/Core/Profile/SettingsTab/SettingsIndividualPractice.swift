import SwiftUI
import Firebase
import FirebaseFirestore

struct SettingsIndividualPractice: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Section {
                Text(settingsViewModel.practiceID)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
            
            Section {
                InfoView(title: "Daily Frequency", value: settingsViewModel.frequency)
                InfoView(title: "Lifetime Count", value: settingsViewModel.count)
            }
            
            Section {
                InfoView(title: "Current Mandala", value: settingsViewModel.mandalaCount)
                InfoView(title: "Mandala Duration", value: settingsViewModel.mandalaDuration)
                InfoView(title: "Mandalas Completed", value: "0")
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                BottomBlueButton(text: "DONE", image: "checkmark.circle", color: Color(.systemBlue), textColor: Color(.white))
            }
        }
        .padding()
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
