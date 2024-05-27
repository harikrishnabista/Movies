//
//  ImageView.swift
//  EbayTest
//
//  Created by Hari Bista on 5/26/24.
//

import SwiftUI

struct ImageView : View {
    
    private let imageRepo: ImageRepositoryProtocol
    private let url: URL?
    
    @State private var image: Image?
    
    init(
        imageRepo: ImageRepositoryProtocol,
        url: URL?
    ) {
        self.imageRepo = imageRepo
        self.url = url
    }

    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            guard let url = url else { return }
            
            imageRepo.getImage(url: url, useCache: true) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    ImageView(
        imageRepo: ImageRepository.shared,
        url: URL(string: "https://image.tmdb.org/t/p/w500/sh7Rg8Er3tFcN9BpKIPOMvALgZd.jpg")
    )
}
