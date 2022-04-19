//
//  Movie.swift
//  MovieTask
//
//

import Foundation

struct Movies: Decodable {
    let Search: [Movie]?
}

struct Movie: Codable {
    let Title: String?
    let Year: String?
    let imdbID: String?
    let Poster: String?
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case Title
        case Year
        case imdbID
        case Poster
        case type = "Type"
    }
    
}



