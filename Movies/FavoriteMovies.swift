//
//  FavoriteMovies.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation

class FavoriteMovies {
    
    @Published var list: [String] = []
    
    func update(isSelected: Bool, movieId: String) {
        
        if isSelected {
            
            if list.contains(movieId) {
                remove(movieId: movieId)
            }
            
            list.append(movieId)
            
        } else {
            remove(movieId: movieId)
        }
    }
    
    private func remove(movieId: String) {
        list.removeAll {
            $0 == movieId
        }
    }
    
    func isFavorite(movieId: String) -> Bool {
        list.contains(movieId)
    }
    
}
