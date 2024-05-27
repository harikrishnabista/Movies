//
//  Movies.swift
//  Movies
//
//  Created by Hari Krishna Bista on 3/27/24.
//

import SwiftUI

@main
struct Movies: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: ContentViewModel(favoriteMovies: FavoriteMovies()))
        }
    }
}
