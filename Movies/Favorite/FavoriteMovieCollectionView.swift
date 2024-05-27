//
//  FavoriteMovieCollectionView.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import SwiftUI

struct FavoriteMovieCollectionView: View {
    @StateObject var vm: FavoriteMovieCollectionViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    
    var body: some View {
        Group {
            if vm.movies.count > 0 {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.movies) { movie in
                            ZStack {
                                cellView(movie: movie)
                            }
                        }
                    }
                    .padding(12)
                }
            } else {
                Text("Please browse movies and add to your favorite list.")
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            vm.onViewAppear()
        }
        
    }
    
    private func cellView(movie: Movie) -> some View {
        ZStack(alignment: .topTrailing) {
            ImageView(imageRepo: ImageRepository.shared, url: movie.imgUrl)
                .cornerRadius(5.0)
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(movie.isFavorite ? .orange : .white)
                .padding(12)
                .onTapGesture {
                    vm.onFavoriteSelectionChanged(movie: movie)
                }
        }
    }
}

#Preview {
    FavoriteMovieCollectionView(
        vm: FavoriteMovieCollectionViewModel(
            movieRepo: MovieRepository(apiCaller: ApiCaller()),
            favMovies: FavoriteMovies()
        )
    )
}
