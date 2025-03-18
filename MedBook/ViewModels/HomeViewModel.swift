//
//  HomeViewModel.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            if searchText.count >= 3 {
                searchBooks()
            } else {
                books.removeAll()
            }
        }
    }
    
    @Published var books: [Book] = []
    @Published var selectedSort: SortOption = .average
    @Published var isLoading = false
    @Published var bookmarks: [String: Bool] = [:]
    @ObservedObject var bookmarkViewModel = BookMarksViewModel()
    
    private var currentOffset = 0
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    private let bookmarkStorage = BookMarksViewModel()
    
    
    init() {
        setupSearchListener()
    }
    
    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Wait 0.5 sec after typing
            .removeDuplicates()
            .sink { [weak self] newText in
                if newText.count >= 3 {
                    self?.searchBooks()
                } else {
                    self?.books.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    func searchBooks() {
        guard searchText.count >= 3 else {
            // books.removeAll()
            return
        }
        
        isLoading = true
        currentOffset = 0 // Reset pagination
        
        Task {
            let fetchedBooks = await apiService.fetchBooks(query: searchText, offset: currentOffset)
            DispatchQueue.main.async {
                self.books = fetchedBooks
                self.isLoading = false
            }
        }
    }
    
    func loadMoreBooks() {
        guard !isLoading else { return }
        isLoading = true
        currentOffset += 10 // Load next 10 books
        
        Task {
            let moreBooks = await apiService.fetchBooks(query: searchText, offset: currentOffset)
            DispatchQueue.main.async {
                self.books.append(contentsOf: moreBooks)
                self.isLoading = false
            }
        }
    }
    
    func sortBooks() {
        switch selectedSort {
        case .title:
            books.sort { $0.title < $1.title }
        case .average:
            books.sort { $0.averageRating > $1.averageRating }
        case .hits:
            books.sort { $0.hits > $1.hits }
        }
    }
    
    func updateSortOption(_ newSort: SortOption) {
         selectedSort = newSort
         sortBooks() // Sort existing data without reloading
     }
    
    func isBookmarked(_ book: Book) -> Bool {
        // return bookmarkViewModel.isBookmarked(book)
        return bookmarks[book.id] ?? false
    }
    
    func toggleBookmark(_ book: Book) {
        //  bookmarkViewModel.toggleBookmark(book)
        if isBookmarked(book) {
            bookmarks[book.id] = false
            bookmarkStorage.toggleBookmark(book)
        } else {
            bookmarks[book.id] = true
            bookmarkStorage.toggleBookmark(book)
        }
        objectWillChange.send()
    }
    
    func loadBookmarks() {
        for book in books {
            bookmarks[book.id] = bookmarkStorage.isBookmarked(book)
        }
    }
}
enum SortOption: String, CaseIterable {
    case title = "Title"
    case average = "Average"
    case hits = "Hits"
}
