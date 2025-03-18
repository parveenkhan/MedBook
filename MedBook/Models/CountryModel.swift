//
//  CountryModel.swift
//  MedBook
//
//  Created by ParveenKhan on 18/03/25.
//


struct Country: Codable {
    let country: String
}

struct CountryResponse: Codable {
    let data: [String: Country]
}
