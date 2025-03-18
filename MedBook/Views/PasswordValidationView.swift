//
//  PasswordValidationView.swift
//  MedBook
//
//  Created by ParveenKhan on 18/03/25.
//

import SwiftUI

struct PasswordValidationView: View {
    var text: String
    var isValid: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? systemImageConstants.checkmarkSquareFill : systemImageConstants.square)
                .foregroundColor(isValid ? .green : .gray)
            Text(text)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
}

#Preview {
    PasswordValidationView(text: "Dua@12345", isValid: true)
}
