//
//  LoginViewMdel.swift
//  MedBook
//
//  Created by ParveenKhan on 17/03/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var navigationPath: [String] = []
    
    // Handle login
    func login() async {
        
        if CoreDataManager.shared.authenticateUser(email: email, password: password) {
            SessionManager.shared.setLoggedIn(email)
            DispatchQueue.main.async {
                self.isAuthenticated = true //Navigate to Home
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid email or password. Please try again."
                self.showError(self.errorMessage ?? "error")
            }
        }
    }
    
    //Auto-login if already logged in
    func checkSession() {
        if SessionManager.shared.isLoggedIn() {
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        }
    }
    
    func showError(_ message: String) {
        NotificationCenter.default.post(name: .showError, object: message)
    }
}

extension Notification.Name {
    static let showError = Notification.Name("showError")
}
