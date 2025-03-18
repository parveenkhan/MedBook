//
//  SearchBar.swift
//  MedBook
//
//  Created by ParveenKhan on 17/03/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search for books", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .onChange(of: text) { _, _ in
                    // Trigger search when text changes
                }

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: systemImageConstants.closeButton)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
