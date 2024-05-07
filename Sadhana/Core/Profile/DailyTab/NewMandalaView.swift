import SwiftUI
import Firebase
import FirebaseFirestore

struct NewMandalaView: View {
    @State var selectedPractice: String = ""
    @State var mandalaDuration: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                Spacer()
                
                Picker(selection: $selectedPractice, label: Text("")) {
                    ForEach(user.practices) { practice in
                        Text(practice.id)
                            .font(.title)
                    }
                }
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)
                .pickerStyle(WheelPickerStyle())
                
                Spacer()
                
                InputView(text: $mandalaDuration, title: "Mandala Duration", placeholder: "Enter the duration for your mandala")
                    .padding()
                
                Spacer()
                
                Button {
                    Task {
                        do {
                            try await Firestore.firestore().collection("users").document(user.id)
                                .collection("practices").document(selectedPractice)
                                .updateData(["mandalaDuration": mandalaDuration, "mandalaCount": "0"])
                        } catch {
                            print("\(error.localizedDescription)")
                        }
                    }
                    
                    dismiss()
                    
                } label: {
                    BottomBlueButton(text: "SAVE", image: "arrow.right", color: Color(.systemBlue), textColor: Color(.white))
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .navigationTitle("New Mandala")
//            .background{
//                LinearGradient(gradient: Gradient(colors: [Color(hex: "#79FF92"), Color(hex: "#B0F8FF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .edgesIgnoringSafeArea(.all)
//            }
        }
    }
}

extension NewMandalaView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !mandalaDuration.isEmpty
        && !selectedPractice.isEmpty
    }
}

struct NewMandalaView_Previews: PreviewProvider {
    static var previews: some View {
        NewMandalaView()
    }
}
