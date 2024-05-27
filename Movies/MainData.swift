//
//  File.swift
//  EbayTest
//
//  Created by Hari Krishna Bista on 3/27/24.
//

import Foundation

struct MainData : Decodable {
    let results: [ResultData]
}

struct ResultData: Decodable {
    let id: Int
    let title: String
    let poster_path: String
}
