//
//  CalendarItemView.swift
//  Sadhana
//
//  Created by Sadhana on 4/24/24.
//

import SwiftUI

struct CalendarItemView: View, Identifiable {
    @State var id: String
    @State var isFinished: Bool
    
    var body: some View {
        HStack {
            Text(id)
                .font(.headline)
                .foregroundColor(.primary)
                    
            Spacer()
                    
            Image(systemName: isFinished ? "checkmark.circle.fill" : "xmark.app.fill")
                .foregroundColor(isFinished ? .green : .red)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct CalendarItemView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarItemView(id: "Shakti Chalana Kriya", isFinished: true)
    }
}
