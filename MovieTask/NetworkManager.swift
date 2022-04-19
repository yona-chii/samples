//
//  NetworkManager.swift
//  MovieTask
//
//

import Foundation
import SystemConfiguration

class NetworkManager {

    private let domainUrlString = "http://www.omdbapi.com/"
    private let apiKey = "b9bd48a6"

    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    func getFilteredMovieList(textFilter:String, completionHandler: @escaping ([Movie]) -> Void) {
        //let url = URL(string: domainUrlString + "?apiKey=")

        let queryItems = [URLQueryItem(name: "apiKey", value: apiKey), URLQueryItem(name: "s", value: textFilter), URLQueryItem(name: "type", value: "movie")]
        var urlComps = URLComponents(string: domainUrlString)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching movies: \(error)")
                return completionHandler([])
            }
      
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return completionHandler([])
            }

            guard let data = data else {
                return completionHandler([])
            }
            
            do {
                let moviesArray = try JSONDecoder().decode(Movies.self, from: data)
                completionHandler(moviesArray.Search ?? [])
            }catch{
                print("error")
                return completionHandler([])
            }

        })
        task.resume()
    }

            func getMovieDetails(movieId: String, completionHandler: @escaping (MovieDetails) -> Void) {
        //let url = URL(string: domainUrlString + "?apiKey=")

        let queryItems = [URLQueryItem(name: "apiKey", value: apiKey), URLQueryItem(name: "i", value: movieId)]
        var urlComps = URLComponents(string: domainUrlString)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching movies: \(error)")
                return
            }
      
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }

            if let data = data,
                let moviesDetails = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                completionHandler(moviesDetails)
            }
        })
        task.resume()
    }
}
