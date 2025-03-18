//
//  UnderlineTextField.swift
//  MedBook
//
//  Created by ParveenKhan on 16/03/25.
//

import SwiftUI

struct UnderlinedTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // TextField or SecureField
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                    .padding(.vertical, 0)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.black)
                    .padding(.vertical, 0)
            }
            
            // Bottom Line
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
        }
    }
}
