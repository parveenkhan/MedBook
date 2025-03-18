//
//  SignUpView.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject private var viewModel = SignupViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavigatingToHome = false
    @State private var isLoading = false
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Welcome Text
                VStack(alignment: .leading) {
                    Text(SignUpViewText.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(SignUpViewText.subtitle)
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                UnderlinedTextField(placeholder: LoginViewText.emailTFPlaceholder, text: $viewModel.email)
                
                UnderlinedTextField(placeholder: LoginViewText.passwordTFPlaceholder, text: $viewModel.password)
                
                // Password Criteria
                VStack(alignment: .leading) {
                    PasswordValidationView(text: SignUpViewText.passwordLengthErrorMessage, isValid: viewModel.isValidPasswordLength)
                        .padding(.top, 10)
                    PasswordValidationView(text: SignUpViewText.passwordUppercaseErrorMessage, isValid: viewModel.hasUppercase)
                        .padding(.top, 10)
                    PasswordValidationView(text: SignUpViewText.passwordSpecialCharErrorMessage, isValid: viewModel.hasSpecialCharacter)
                        .padding(.top, 10)
                }
                .padding(.top, 20)
                
                // Country Picker
                VStack {
                    Picker(selection: $viewModel.selectedCountry, label: Text(SignUpViewText.pickerTitle).foregroundStyle(.black)) {
                        ForEach(viewModel.countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .background(Color(.clear))
                    .cornerRadius(8)
                    .clipped()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                // Signup Button
                Button(action: {
                    Task {
                        await viewModel.signup()
                        if viewModel.isSignedUp {
                            isNavigatingToHome = true
                        }
                    }
                }) {
                    HStack {
                        Text(SignUpViewText.signupBtnTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: systemImageConstants.arrowRight)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                    .padding()
                    .background(viewModel.isValidPassword && !viewModel.email.isEmpty ? Color.black : Color.gray)
                    .cornerRadius(10)
                }
                .disabled(!viewModel.isValidPassword || viewModel.email.isEmpty)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
                //  }
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $isNavigatingToHome) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
                
            }
            .onAppear {
                viewModel.fetchCountryList()
            }
            
        }
    }    
}


#Preview {
    SignupView()
}
