//
//  MovieCollectionView.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import SwiftUI

struct MovieCollectionView: View {
    
    @StateObject var vm: MovieCollectionViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    
    var body: some View {
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

struct Movie : Identifiable {
    var id: String
    let title: String
    let imgUrl: URL?
    let isFavorite: Bool
}

#Preview {
    MovieCollectionView(
        vm: MovieCollectionViewModel(
            movieRepo: MovieRepository(networkService: NetworkService()),
            favMovies: FavoriteMovies()
        )
    )
}
