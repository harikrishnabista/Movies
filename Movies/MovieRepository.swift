//
//  MovieRepository.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation

class MovieRepository {
    
    private let apiCaller: ApiCaller
    init(apiCaller: ApiCaller) {
        self.apiCaller = apiCaller
    }
    
    let apiKey = "f130610f7b157c8e887136a6c6547353"
    
    let apiUrl = "https://api.themoviedb.org/3/discover/movie?api_key=f130610f7b157c8e887136a6c6547353&sort_by=popularity.desc"
    
    func getMovies(
        completion: @escaping (Result<MainData, ApiError>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else { return }
        apiCaller.getData(url: url, completion: completion)
    }
}
