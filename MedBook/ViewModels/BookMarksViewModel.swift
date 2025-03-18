//
//  BookMarksViewModel.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import Foundation

class BookMarksViewModel: ObservableObject {
    @Published var bookmarkedBooks: [Book] = []
    
    private let bookmarkKey = "bookmarked_books"

    init() {
        loadBookmarks()
    }
    
    // Save bookmarks
    func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarkedBooks) {
            UserDefaults.standard.set(encoded, forKey: bookmarkKey)
        }
    }
    
    // Load bookmarks
    func loadBookmarks() {
        if let savedData = UserDefaults.standard.data(forKey: bookmarkKey),
           let decoded = try? JSONDecoder().decode([Book].self, from: savedData) {
            bookmarkedBooks = decoded
        }
    }
    
    // Toggle bookmark (Add or Remove)
    func toggleBookmark(_ book: Book) {
        if let index = bookmarkedBooks.firstIndex(where: { $0.id == book.id }) {
            // Remove if already bookmarked
            bookmarkedBooks.remove(at: index)
        } else {
            // Add to bookmarks
            bookmarkedBooks.append(book)
        }
        saveBookmarks()
    }

    // Check if a book is bookmarked
    func isBookmarked(_ book: Book) -> Bool {
        return bookmarkedBooks.contains(where: { $0.id == book.id })
    }
}
