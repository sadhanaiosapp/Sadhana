//
//  SwiftUIView.swift
//  Sadhana
//
//  Created by Sadhana on 5/1/24.
//

import SwiftUI

struct SettingsMyPracticeNavigationLink: View {
    var displayText: String
        
    var body: some View {
        Text(displayText)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
    }
}

struct SettingsMyPracticeNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMyPracticeNavigationLink(displayText: "Shakti Chalana Kriya")
    }
}
