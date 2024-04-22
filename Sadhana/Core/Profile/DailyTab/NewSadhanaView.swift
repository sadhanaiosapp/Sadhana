import SwiftUI

struct NewSadhanaView: View {
    @State var practiceName = ""
    @State var frequency = ""
    @State var mandala = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
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
            
            Button {
                //IMPLEMENT SAVE USER DATA TO FIREBASE
                dismiss()
            } label: {
                HStack {
                    Text("SAVE")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(Color(.white))
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.bottom, 30)
        }
        .navigationTitle("New Sadhana")
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
