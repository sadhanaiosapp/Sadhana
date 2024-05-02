//
//  SwiftUIView.swift
//  Sadhana
//
//  Created by Sadhana on 5/1/24.
//

import SwiftUI

struct SettingsMyPracticeNavigationLink: View {
    var practiceID: String
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    
    var body: some View {
        
        Text(practiceID)
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#79FF92"), Color(hex: "#B0F8FF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
            )
            .padding([.leading, .trailing], 16)
        
    }
}

struct SettingsMyPracticeNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMyPracticeNavigationLink(practiceID: "Shakti Chalana Kriya")
    }
}
