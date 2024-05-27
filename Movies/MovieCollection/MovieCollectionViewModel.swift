//
//  MovieCollectionViewModel.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation
import Combine

class MovieCollectionViewModel: ObservableObject {
    
    private let movieRepo: MovieRepository
    private let favMovies: FavoriteMovies
    init(
        movieRepo: MovieRepository,
        favMovies: FavoriteMovies
    ) {
        self.movieRepo = movieRepo
        self.favMovies = favMovies
        
        bindFavMovies()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func bindFavMovies() {
        favMovies
            .$list
            .receive(on: RunLoop.main)
            .sink { newList in
                self.publishMoviesList()
            }.store(in: &cancellables)
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
        
        return mainData.results.map {
            
            let movieId = "\($0.id)"
            
            return Movie(
                id: movieId,
                title: $0.title,
                imgUrl: getMovieUrl(posterPath: $0.poster_path),
                isFavorite: favMovies.isFavorite(movieId: movieId)
            )
        }
    }
    
    func getMovieUrl(posterPath: String) -> URL? {
        let urlString = "https://image.tmdb.org/t/p/w500" + posterPath
        return URL(string: urlString)
    }
    
    private func loadMovies() {
        
        movieRepo.getMovies() { (result: Result<MainData, NetworkServiceError>) in
            
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
    }
    
}
