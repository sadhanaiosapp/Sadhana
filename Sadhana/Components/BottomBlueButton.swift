//
//  BottomBlueButton.swift
//  Sadhana
//
//  Created by Sadhana on 5/2/24.
//

import SwiftUI

struct BottomBlueButton: View {
    
    var text: String
    var image: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
            Image(systemName: image)
        }
        .foregroundColor(Color(.white))
        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        .background(Color(.systemBlue))
        .cornerRadius(10)
        .padding(.bottom, 30)
    }
}

struct BottomBlueButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomBlueButton(text: "SAVE", image: "arrow.right")
    }
}
