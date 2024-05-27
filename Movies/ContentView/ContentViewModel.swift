//
//  ContentViewModel.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation
import Combine

class ContentViewModel : ObservableObject {
    
    var favoriteMovies: FavoriteMovies
    
    init(favoriteMovies: FavoriteMovies) {
        self.favoriteMovies = favoriteMovies
        
        bindFavoriteMoviesCount()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func bindFavoriteMoviesCount() {
        favoriteMovies
            .$count
            .receive(on: RunLoop.main)
            .sink { newValue in
                self.publishFavoriteMovieTitle(count: newValue)
            }.store(in: &cancellables)
    }
    
    @Published var favoriteMovieTitle = "Favorite"
    
    private func publishFavoriteMovieTitle(count: Int) {
        if count > 0 {
            favoriteMovieTitle = "Favorite: \(count)"
        } else {
            favoriteMovieTitle = "Favorite"
        }
    }
    
}
