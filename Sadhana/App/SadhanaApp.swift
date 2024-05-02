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
    @StateObject var viewModel = AuthViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(calendarViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(friendsViewModel)
        }
    }
}
