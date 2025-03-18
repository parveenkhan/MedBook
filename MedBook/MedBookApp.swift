//
//  MedBookApp.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

@main
struct MedBookApp: App {
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                ContentView()

            }
        }
    }
}
