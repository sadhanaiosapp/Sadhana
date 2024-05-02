import SwiftUI
import Firebase
import FirebaseFirestore

struct SettingsIndividualPractice: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(settingsViewModel.practiceID)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
            InfoView(title: "Daily Frequency", value: settingsViewModel.frequency)
            InfoView(title: "Current Mandala", value: settingsViewModel.mandalaCount)
            InfoView(title: "Mandala Duration", value: settingsViewModel.mandala)
            InfoView(title: "Lifetime Count", value: settingsViewModel.count)
                
            Spacer()
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
            
            Spacer()
            
            Text(value)
                .foregroundColor(.black)
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x79FF92), Color(hex: 0xB0F8FF)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 16)
    }
}

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: 1
        )
    }
}
