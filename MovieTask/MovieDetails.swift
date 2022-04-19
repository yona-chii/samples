//
//  MovieDetails.swift
//  MovieTask
//
//

import Foundation

struct MovieDetails: Codable {
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Language: String?
    let Country: String?
    let Awards: String?
    let Poster: String?
    let Metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let DVD: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
    let Response: String?
    let Ratings: Array<RatingDetails>?

    /*enum CodingKeys: String, CodingKey {
        case movieType = "Type"
    }
    init(type: String) {
    self.movieType = type
    }*/
    
}

struct RatingDetails: Codable {
    let Source: String?
    let Value: String?
}
