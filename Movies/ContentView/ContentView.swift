//
//  ContentView.swift
//  EbayTest
//
//  Created by Hari Krishna Bista on 3/27/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm: ContentViewModel
    
    var body: some View {
        
        TabView {
            
            MovieCollectionView(
                vm: MovieCollectionViewModel(
                    movieRepo: MovieRepository(apiCaller: ApiCaller()),
                    favMovies: vm.favoriteMovies
                )
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Movies")
            }
            
            FavoriteMovieCollectionView(
                vm: FavoriteMovieCollectionViewModel(
                    movieRepo: MovieRepository(apiCaller: ApiCaller()),
                    favMovies: vm.favoriteMovies
                )
            )
            .tabItem {
                Image(systemName: "star.fill")
                Text(vm.favoriteMovieTitle)
            }
        }
        
    }
}

#Preview {
    ContentView(vm: ContentViewModel(favoriteMovies: FavoriteMovies()))
}
