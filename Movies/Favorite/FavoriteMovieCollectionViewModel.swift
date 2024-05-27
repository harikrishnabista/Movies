//
//  FavoriteMovieCollectionViewModel.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation

class FavoriteMovieCollectionViewModel: ObservableObject {
    
    private let movieRepo: MovieRepository
    private let favMovies: FavoriteMovies
    init(
        movieRepo: MovieRepository,
        favMovies: FavoriteMovies
    ) {
        self.movieRepo = movieRepo
        self.favMovies = favMovies
    }
    
    func onViewAppear() {
        loadMovies()
    }
    
    private var mainData: MainData? {
        didSet {
            publishMoviesList()
        }
    }
    
    @Published var movies: [Movie] = []
    
    private func publishMoviesList() {
        movies = movieList
    }
    
    private var movieList: [Movie] {
        guard let mainData = mainData else { return [] }
        
        return mainData.results
            .filter { favMovies.isFavorite(movieId: "\($0.id)") }
            .map {
                let movieId = "\($0.id)"
                return Movie(
                    id: movieId,
                    title: $0.title,
                    imgUrl: getMovieUrl(posterPath: $0.poster_path),
                    isFavorite: favMovies.isFavorite(movieId: movieId) == true
                )
            }
    }
    
    func getMovieUrl(posterPath: String) -> URL? {
        let urlString = "https://image.tmdb.org/t/p/w500" + posterPath
        return URL(string: urlString)
    }
    
    private func loadMovies() {
        
        movieRepo.getMovies() { (result: Result<MainData, ApiError>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let mainData):
                    self.mainData = mainData
                case .failure(let apiError):
                    print(apiError.message)
                }
            }
            
        }
    }
    
    func onFavoriteSelectionChanged(movie: Movie) {
        favMovies.update(
            isSelected: !movie.isFavorite,
            movieId: movie.id
        )
        
        publishMoviesList()
    }
    
}
