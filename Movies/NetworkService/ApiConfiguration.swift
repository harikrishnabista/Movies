//
//  ApiConfiguration.swift
//  NetworkService
//
//  Created by Hari Krishna Bista on 5/16/24.
//

import Foundation

protocol APIConfiguration {
    var urlPath: String { get }
    var parameters: [URLQueryItem] { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable?{ get }
}

struct ApiConfiguration : APIConfiguration {
    
    let urlPath: String
    let parameters: [URLQueryItem]
    let method: APIMethod
    let headers: [String : String]?
    let body: (any Encodable)?
    
    init(
        urlPath: String,
        parameters: [URLQueryItem] = [],
        method: APIMethod = .get,
        headers: [String : String]? = nil,
        body: (any Encodable)? = nil
    ) {
        self.urlPath = urlPath
        self.parameters = parameters
        self.method = method
        self.headers = headers
        self.body = body
    }
    
}

enum APIMethod {
    case get, post, patch, put, delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
