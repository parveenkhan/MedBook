//
//  BookModel.swift
//  MedBook
//
//  Created by ParveenKhan on 15/03/25.
//


struct Book: Identifiable, Equatable, Codable {
    let id: String
    let title: String
    let author: String
    let averageRating: Double
    let hits: Int
    let coverImage: String?
}
