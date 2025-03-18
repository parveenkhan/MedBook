//
//  ContentView.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    CurvedTopBackground()
                        .frame(height: UIScreen.main.bounds.height * 0.25) // Top 1/4 screen
                        .foregroundColor(AppColor.curvedTopbackground)
                    
                    Spacer()
                }
                .background(AppColor.primary)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    // Spacer()
                    
                    // App Title
                    Text(LandingViewText.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 40, leading: 10, bottom: 0, trailing: 0))
                    // Illustration Image
                    Image(AppImageConstants.logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.37)
                        .padding(.vertical, 20)
                    Spacer()
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: SignupView()) {
                            Text(LandingViewText.signUpButtonTitle)
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                                .background(.white)
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            Text(LandingViewText.loginButtonTitle)
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                                .background(.white)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
                .padding()
                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
