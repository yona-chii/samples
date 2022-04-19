//
//  MovieDetailsViewController.swift
//  MovieTask
//
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieTime: UILabel!
    @IBOutlet weak var movieCategories: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieReview: UILabel!
    @IBOutlet weak var movieDirectors: UILabel!
    @IBOutlet weak var movieWriters: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    @IBOutlet weak var moviePosterView: UIImageView!
    
    private var movieId: String?
    private var movieDetailsHolder: MovieDetails?
    
    func setMovieId(id:String) { movieId = id }
    
    override func viewDidLoad() {
        showLoading()
        getMovieDetails(mId: movieId ?? "0")
    }

    func showLoading() {
        loadingIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    func setData() {
        navigationItem.title = movieDetailsHolder?.Title
        movieTitle.text = movieDetailsHolder?.Title
        movieYear.text = movieDetailsHolder?.Year
        movieTime.text = "Runtime: "+(movieDetailsHolder?.Runtime ?? "unknown")
        movieCategories.text = movieDetailsHolder?.Genre
        movieRating.text = movieDetailsHolder?.imdbRating
        movieSummary.text = movieDetailsHolder?.Plot
        movieScore.text = movieDetailsHolder?.imdbRating
        movieReview.text = movieDetailsHolder?.imdbVotes
        movieDirectors.text = movieDetailsHolder?.Director
        movieWriters.text = movieDetailsHolder?.Writer
        movieActors.text = movieDetailsHolder?.Actors
        moviePosterView.image = setPosterFromUrl(posterUrl: movieDetailsHolder?.Poster ?? "")
        moviePosterView.contentMode = .scaleAspectFit
    }

    func getMovieDetails(mId: String) {
        NetworkManager().getMovieDetails(movieId: mId, completionHandler: { [weak self] (movieDetails) in
            self?.movieDetailsHolder = movieDetails
            
            DispatchQueue.main.async {
                self?.setData()
                self?.hideLoading()
            }
        })
    }
    
    func setPosterFromUrl(posterUrl:String) -> UIImage? {
        let imageurl = URL(string: posterUrl)
        
        if let imagedata = try? Data(contentsOf: imageurl! as URL) {
            return UIImage(data: imagedata as Data)
        }
        return nil
    }
}
