//
//  HomeView.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(HomeViewText.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Navigate to Bookmarks Screen
                    NavigationLink(destination: BookmarksView()) {
                        Image(systemName: systemImageConstants.bookmarkFill)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: handleLogout) {
                        Image(systemName: systemImageConstants.logout)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                
                if !viewModel.books.isEmpty {
                    HStack {
                        Text(HomeViewText.sortByTitle)
                            .font(.headline)
                        Picker(HomeViewText.pickerTitle, selection: $viewModel.selectedSort) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: viewModel.selectedSort) { _, newSort in
                            viewModel.updateSortOption(newSort) //Sort without refetching
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Book List
                List {
                    ForEach(viewModel.books, id: \.id) { book in
                        let isBookmarkedBinding = Binding<Bool>(
                            get: { viewModel.bookmarks[book.id] ?? false },
                            set: { newValue in
                                viewModel.bookmarks[book.id] = newValue
                                viewModel.toggleBookmark(book)
                            }
                        )
                        
                        BookRowView(book: book, isBookmarked: isBookmarkedBinding) {
                            viewModel.toggleBookmark(book)
                        }
                        .onAppear {
                            if book == viewModel.books.last {
                                viewModel.loadMoreBooks()
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func handleLogout() {
         isLoggedIn = false
     }
}

#Preview {
    HomeView()
}
