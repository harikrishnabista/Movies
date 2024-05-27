//
//  ImageRepository.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import Foundation
import SwiftUI

protocol ImageRepositoryProtocol {
    func getImage(
        url: URL,
        useCache: Bool,
        completion: @escaping (Image?) -> Void
    )
}

class ImageRepository: ImageRepositoryProtocol {
    
    static var shared = ImageRepository()
    
    private init() { }
    
    private var dict: [URL: Image] = [:]
    
    func getImage(
        url: URL,
        useCache: Bool,
        completion: @escaping (Image?) -> Void
    ) {
        if let image = dict[url] {
            completion(image)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                guard let uiImage = UIImage(data: data) else { return }
                
                let image = Image(uiImage: uiImage)
                
                if useCache {
                    self.dict[url] = image
                }
                
                completion(image)
            }
            .resume()
        }
    }
}
