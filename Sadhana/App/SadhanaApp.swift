//
//  SadhanaApp.swift
//  Sadhana
//
//  Created by Sadhana on 4/19/24.
//

import SwiftUI
import Firebase

@main
struct SadhanaApp: App {
    @State private var isLoading = true
    @StateObject var viewModel = AuthViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(viewModel)
                    .environmentObject(calendarViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(friendsViewModel)
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Image("TransparentLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
        }
    }
}

