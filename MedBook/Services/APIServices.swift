//
//  APIServices.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//

import Foundation

struct APIConstant{
    
    static let fetchBookUrl = "https://openlibrary.org/search.json"
    static let coverImageUrl = "https://covers.openlibrary.org/b/id/"
    static let countryList = "https://api.first.org/data/v1/countries"
    static let getIP = "http://ip-api.com/json"
    
}

class APIService {
    func fetchBooks(query: String, offset: Int) async -> [Book] {
        let urlString = "\(APIConstant.fetchBookUrl)?title=\(query)&limit=10&offset=\(offset)"
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
            
            return decodedResponse.docs.map { book in
                Book(
                                   id: book.key,
                                   title: book.title,
                                   author: book.authorName?.first ?? "Unknown",
                                   averageRating: book.ratingsAverage ?? 0.0,
                                   hits: book.ratingsCount ?? 0,
                                   coverImage: book.coverI != nil ? "\(APIConstant.coverImageUrl)\(book.coverI!)-M.jpg" : nil
                               )
            }
        } catch {
            print("Error fetching books:", error)
            return []
        }
    }
    
    func fetchCountries() async -> [String]? {
        guard let url = URL(string: APIConstant.countryList) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodeResponse = try JSONDecoder().decode(CountryResponse.self, from: data)
            return decodeResponse.data.values.map { $0.country }
            
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func fetchUserIPAndSetCountry() async -> String {
        guard let url = URL(string: APIConstant.getIP) else { return "India" }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(IPResponse.self, from: data)
                    let selectedCountry = decodedResponse.country
                    return selectedCountry
            } catch {
                print("Failed to fetch IP data: \(error)")
                return "India"
            }
    }

    
}

struct OpenLibraryResponse: Codable {
    let numFound: Int? // Total results count
    let start: Int? // Pagination start index
    let docs: [OpenLibraryBook] // Book array
}

struct OpenLibraryBook: Codable {
    let key: String
    let title: String
    let authorName: [String]?
    let ratingsAverage: Double?
    let ratingsCount: Int?
    let coverI: Int? // JSON field "cover_i"

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case coverI = "cover_i"
    }
}

