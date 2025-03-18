//
//  BookmarksView.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import SwiftUI

struct BookmarksView: View {
    @StateObject var viewModel = BookMarksViewModel()

    var body: some View {
            VStack(alignment: .leading) {
                Text(BookMarkedViewText.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                if viewModel.bookmarkedBooks.isEmpty {
                    Spacer()
                    Text(BookMarkedViewText.emptyMessage)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.bookmarkedBooks, id: \.id) { book in
                            BookRowView(book: book, isBookmarked: Binding(
                                get: { viewModel.isBookmarked(book) },
                                set: { _ in viewModel.toggleBookmark(book) }
                            )){
                                viewModel.toggleBookmark(book)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .navigationTitle(BookMarkedViewText.navigationTitle)
    }
}


#Preview {
    BookmarksView()
}
