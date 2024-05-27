//
//  ApiCaller.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation

struct ApiError: Error {
    let message: String
}

class ApiCaller {
    func getData<T: Decodable> (
        url: URL,
        completion: @escaping (_ result: Result<T, ApiError>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
            guard let data = data 
            else {
                completion(Result.failure(ApiError(message: "No data")))
                return
            }
                
            do {
                
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(obj))
                
            } catch let error {
                completion(Result.failure(ApiError(message: error.localizedDescription)))
            }
        }

        task.resume()
    }
}
