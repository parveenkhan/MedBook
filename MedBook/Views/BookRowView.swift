//
//  BookRowView.swift
//  MedBook
//
//  Created by ParveenKhan on 16/03/25.
//

import SwiftUI

struct BookRowView: View {
    let book: Book
    @Binding var isBookmarked: Bool
    let onBookmarkToggle: () -> Void

    var body: some View {
        HStack {
            if let imageUrl = book.coverImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.frame(width: 50, height: 70)
                }
                .frame(width: 50, height: 70)
                .cornerRadius(5)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(1)
                
                
                HStack {
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Image(systemName: systemImageConstants.starFill).foregroundColor(.yellow)
                    Text("\(book.averageRating, specifier: "%.1f")")
                    Spacer()
                    Image(systemName: systemImageConstants.eyeFill).foregroundColor(.gray)
                    Text("\(book.hits)")
                }
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(10)
        .swipeActions(edge: .trailing) {
            Button(action: {
                isBookmarked.toggle()
                onBookmarkToggle()
            }) {
                Label(isBookmarked ? BookMarkedViewText.Untag : BookMarkedViewText.Tag, systemImage: isBookmarked ? systemImageConstants.bookmarkFill : systemImageConstants.bookmark)
            }
            .tint(isBookmarked ? .red : .green)
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
            viewModel.books = [
                Book(id: "1", title: "A Game of Thrones", author: "George R. R. Martin", averageRating: 4.2, hits: 376, coverImage: "https://covers.openlibrary.org/b/id/123456-M.jpg"),
                Book(id: "2", title: "A Game of You", author: "Neil Gaiman", averageRating: 4.4, hits: 32, coverImage: "https://covers.openlibrary.org/b/id/654321-M.jpg")
            ]
            
            return HomeView()
                .environmentObject(viewModel)
}
