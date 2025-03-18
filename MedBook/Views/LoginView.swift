//
//  LoginView.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var isNavigatingToHome = false
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    CurvedTopBackground()
                        .frame(height: UIScreen.main.bounds.height * 0.25) 
                        .foregroundColor(AppColor.curvedTopbackground)
                    
                    Spacer()
                }
                .background(AppColor.primary)
                .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                
                    // Welcome Text
                    VStack(alignment: .leading) {
                        Text(LoginViewText.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(LoginViewText.subtitle)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                    UnderlinedTextField(placeholder: LoginViewText.emailTFPlaceholder, text: $viewModel.email)
                                        
                    UnderlinedTextField(placeholder: LoginViewText.passwordTFPlaceholder, text: $viewModel.password, isSecure: true)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    
                    Spacer()
                    
                    // Login Button
                    Button(action: {
                        Task {
                            await viewModel.login()
                            if viewModel.isAuthenticated {
                                isNavigatingToHome = true
                            }
                        }
                    }) {
                            HStack {
                                Text(LoginViewText.loginBtnTitle)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: systemImageConstants.arrowRight)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                        .padding(.bottom, 30)
                        .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                        .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.5 : 1.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    NavigationLink(value: "HomeView") {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding(.horizontal, 20)
                .alert(isPresented: $showAlert) { //Show alert when `showAlert` is true
                          Alert(
                            title: Text(AlertText.title),
                              message: Text(errorMessage),
                            dismissButton: .default(Text(AlertText.dismissBtnTitle))
                          )
                      }
                .navigationDestination(isPresented: $isNavigatingToHome) {
                    HomeView()
                        .navigationBarBackButtonHidden(true)

                }
                .onAppear() {
                    viewModel.checkSession()
                    NotificationCenter.default.addObserver(forName: .showError, object: nil, queue: .main) { notification in
                            if let message = notification.object as? String {
                                showError(message)
                            }
                        }
                }
            }
        }
    }
    
    private func showError(_ message: String) {
            errorMessage = message
            showAlert = true
        }
}

#Preview {
    LoginView()
}

