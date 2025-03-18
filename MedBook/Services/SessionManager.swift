//
//  SessionManager.swift
//  MedBook
//
//  Created by ParveenKhan on 17/03/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    private let userDefaults = UserDefaults.standard
    private let loggedInKey = "isLoggedIn"
    private let loggedInEmailKey = "loggedInEmail"

    private init() {}

    // Save login status
    func setLoggedIn(_ email: String) {
        userDefaults.set(true, forKey: loggedInKey)
        userDefaults.set(email, forKey: loggedInEmailKey)
    }

    // Logout user
    func logout() {
        userDefaults.set(false, forKey: loggedInKey)
        userDefaults.removeObject(forKey: loggedInEmailKey)
    }

    // Check if user is logged in
    func isLoggedIn() -> Bool {
        return userDefaults.bool(forKey: loggedInKey)
    }

    // Get logged-in user's email
    func getLoggedInEmail() -> String? {
        return userDefaults.string(forKey: loggedInEmailKey)
    }
}
