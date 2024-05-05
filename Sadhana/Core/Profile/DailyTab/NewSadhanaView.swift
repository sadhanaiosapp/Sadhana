import SwiftUI
import Firebase
import FirebaseFirestore

struct NewSadhanaView: View {
    @State var practiceName = ""
    @State var frequency = ""
    @State var mandala = ""
    @State var mandalaCount = "0"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                //Form Fields
                VStack(spacing: 24) {
                    InputView(text: $practiceName, title: "What is your new practice?", placeholder: "Name of Practice")
                        .autocapitalization(.none)
                    InputView(text: $frequency, title: "How many times a day do you aim to practice?", placeholder: "Frequency")
                        .autocapitalization(.none)
                    InputView(text: $mandala, title: "Please enter duration of mandala if you are planning to do one. Otherwise, leave blank.", placeholder: "Duration")
                }
                .padding(.horizontal, 15)
                .padding(.top, 12)
                
                
                Spacer()
                
                //Save Button
                Button {
                    Task {
                        do {
                            let defaults = UserDefaults.standard
                            defaults.set(false, forKey: practiceName)
                            
                            try await Firestore.firestore().collection("users").document(user.id)
                                .collection("practices").document(practiceName)
                                .setData(["frequency": frequency, "mandala": mandala, "mandalaCount": "0", "count": "0"])
                            
                            viewModel.currentUser?.practices.append(ToDoListItem(id: practiceName, frequency: frequency, mandala: mandala, mandalaCount: "0", count: "0"))
                        } catch {
                            print("\(error.localizedDescription)")
                        }
                    }
                    
                    dismiss()
                    
                } label: {
                    BottomBlueButton(text: "SAVE", image: "arrow.right")
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)

            }
            .navigationTitle("New Sadhana")
        }
    }
}

extension NewSadhanaView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !practiceName.isEmpty
        && !frequency.isEmpty
    }
}

struct NewSadhanaView_Previews: PreviewProvider {
    static var previews: some View {
        NewSadhanaView()
    }
}
