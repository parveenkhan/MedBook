//
//  SignupViewModel.swift
//  MedBook
//
//  Created by ParveenKhan on 17/03/25.
//

import SwiftUI
import Combine

class SignupViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    @Published var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    @Published var confirmPassword: String = ""
    @Published var selectedCountry: String = "Select Country"
    @Published var countries: [String] = []
    @Published var isValidEmail = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var isValidPasswordLength = false
    @Published var hasUppercase = false
    @Published var hasNumber = false
    @Published var hasSpecialCharacter = false
    @Published var isSignedUp = false //Track signup status
    
    @Published var navigationPath: [String] = []
    
    private let countryKey = "saved_countries"
    private let selectedCountryKey = "selected_country"
    private let apiService = APIService()
    
    
    var isValidPassword: Bool {
            return isValidPasswordLength && hasUppercase && hasNumber && hasSpecialCharacter
        }
    
    // Checks if signup button should be enabled
       var isSignupEnabled: Bool {
           return isValidEmail && isValidPassword && !selectedCountry.isEmpty
       }


    init()  {
        fetchUserIPAndSetCountry()
    }
    
    // Validate email format
    func validateEmail() {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isValidEmail = emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword() {
            // Check individual requirements
            isValidPasswordLength = password.count >= 8
            hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
            hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
            hasSpecialCharacter = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$&*")) != nil
        }
    
    // Fetch user IP and set default country
    func fetchUserIPAndSetCountry() {
        
        self.isLoading = true
        Task {
            let ipResponse = await apiService.fetchUserIPAndSetCountry()
            DispatchQueue.main.async {
                self.isLoading = false
                self.selectedCountry = ipResponse
                UserDefaults.standard.set(self.selectedCountry, forKey: self.selectedCountryKey)
                
            }
        }
    }
    
    func fetchCountryList() {
        
        self.isLoading = true
        
        Task {
            let fetchedBooks = await apiService.fetchCountries()
            DispatchQueue.main.async {
                self.countries = fetchedBooks ?? []
                self.isLoading = false
            }
        }
    }

    func signup() async  {
        guard isSignupEnabled else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter valid details."
            }
            return
        }
        
        let context = CoreDataManager.shared.context
        
        //Check if user already exists
        if CoreDataManager.shared.userExists(email: email) {
            DispatchQueue.main.async {
                self.errorMessage = "Email already registered. Try logging in."
            }
            return
        }
        
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password
        newUser.country = selectedCountry
        
        do {
            try context.save()
            DispatchQueue.main.async {
                self.isSignedUp = true
                print("User registered successfully.")
            }
        } catch {
            DispatchQueue.main.async {
                print("Failed to save user: \(error)")
                self.errorMessage = "Signup failed. Try again."
            }
        }
    }

}
