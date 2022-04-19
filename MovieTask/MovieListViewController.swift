//
//  MovieListView.swift
//  MovieTask
//

import Foundation
import UIKit

class MovieListViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {
    
    //UI elemets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    private var movies: [Movie]?
    private var selectedMovieId: String = "0"
    private var hasConnection = false

    private let reuseIdentifier = "MovieListCell"
    
    override func viewDidLoad() {
        navigationItem.title = "Film List"
        hasConnection = getConnection()

        searchBar.delegate = self
        self.movieCollectionView.delegate = self
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.register(UINib(nibName: reuseIdentifier, bundle:nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetails" {
            let nextView = segue.destination as? MovieDetailsViewController
            nextView?.setMovieId(id: selectedMovieId)
        }
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        performSegue(withIdentifier: "SegueToDetails", sender: self)
    }
    
    func getConnection() -> Bool {
        if NetworkManager().isConnectedToNetwork() {
            return true
        }
        label.text = "Connect to the Internet to start searching for movies!"
        return false
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
    }


    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if !hasConnection {
            getConnection()
        }
        return true
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showLoading()
        self.searchBar.resignFirstResponder()
        getFilteredMoviesList(filter: searchBar.searchTextField.text ?? "")
    }
    

    func getFilteredMoviesList(filter: String) {
        NetworkManager().getFilteredMovieList(textFilter: filter, completionHandler: { [weak self] (movies) in
            self?.movies = movies

            DispatchQueue.main.async {
                if movies.count == 0 {
                    self?.label.text = "No Results found."
                    self?.label.isHidden = false
                } else {
                    self?.label.isHidden = true
                }
                
                self?.movieCollectionView.reloadData()
                self?.hideLoading();
            }
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieId = self.movies?[indexPath.item].imdbID ?? "0"
        performSegue(withIdentifier: "SegueToDetails", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: reuseIdentifier,
          for: indexPath
        ) as! MovieListCell

        let currMovie = self.movies?[indexPath.item]

        cell.backgroundColor = .white
        cell.movieTitle.text = currMovie?.Title
        cell.moviePoster.image = setPosterFromUrl(posterUrl: currMovie?.Poster ?? "")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies?.count ?? 0
    }
    
    func setPosterFromUrl(posterUrl:String) -> UIImage? {
        let imageurl = URL(string: posterUrl)
        
        if let imagedata = try? Data(contentsOf: imageurl! as URL) {
            return UIImage(data: imagedata as Data)
        }
        return nil
    }
}

extension UIViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let leftAndRightPaddings: CGFloat = 45.0
//        let numberOfItemsPerRow: CGFloat = 2.0
//
//        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
//        return CGSize(width: width, height: width)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = (collectionView.frame.width - 10 ) / 2
                
        return CGSize(width:widthPerItem, height: widthPerItem * 1.48)
    
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//    }
}
