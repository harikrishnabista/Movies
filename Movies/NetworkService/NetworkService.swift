//
//  NetworkService.swift
//  NetworkService
//
//  Created by Hari Krishna Bista on 5/7/23.
//

import Foundation

protocol NetworkServiceProtocol {
    @discardableResult
    func call<T: Decodable>(
        _ config: any APIConfiguration,
        _ completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask?
}

struct NetworkService: NetworkServiceProtocol {
    @discardableResult
    func call<T: Decodable>(
        _ config: any APIConfiguration,
        _ completion: @escaping (Result<T, NetworkServiceError>) -> Void
    ) -> URLSessionDataTask? {
        
        guard let url = URL(string: config.urlPath),
              let urlrequest = getRequest(config, url: url)
        else {
            let err = NetworkServiceError(message: "URL request error.")
            printError(err)
            completion(Result.failure(err))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: urlrequest) { (data, respose, error) in
            do {
                if let data = data {
                    printResponseData(data)
                    let returnObj = try JSONDecoder().decode(T.self, from: data)
                    completion(Result.success(returnObj))
                } else if let error = error {
                    let err = NetworkServiceError(message: error.localizedDescription)
                    printError(err)
                    completion(Result.failure(err))
                }
            } catch let error {
                let err = NetworkServiceError(message: error.localizedDescription)
                printError(err)
                completion(Result.failure(err))
            }
        }
        
        printRequest(urlrequest)
        
        task.resume()
        
        return task
    }
    
    private func getRequest(_ config: APIConfiguration, url: URL) -> URLRequest? {
        
        var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        
        if !config.parameters.isEmpty {
            urlComponents?.queryItems = config.parameters
        }
        
        if let fullURL = urlComponents?.url {
            var request = URLRequest(url: fullURL)
            request.httpMethod = config.method.description
            request.allHTTPHeaderFields = config.headers
            request.httpBody = config.body?.jsonEncodedData
            return request
        }
        
        return nil
        
    }

}

extension NetworkServiceProtocol {
    func printError(_ error: NetworkServiceError) {
        print("[NetworkService] - error: \(error.message)")
    }
    
    func printResponseData(_ data: Data) {
        guard let str = String(data: data, encoding: .utf8) else { return }
        print("[NetworkService] - responseData:")
        print(str)
    }
    
    func printRequest(_ request: URLRequest) {
        guard let url = request.url else { return }
        print("[NetworkService] - request: \(url)")
        
        guard let body = request.httpBody,
              let bodyStr = String(data: body, encoding: .utf8) else { return }
        print("[NetworkService] - body: \(bodyStr)")
        
        guard let headers = request.allHTTPHeaderFields else { return }
        print("[NetworkService] - headers: \(headers)")
    }
}

struct NetworkServiceError: Error {
    let message: String
}

extension Encodable {
    var jsonEncodedData: Data? {
        try? JSONEncoder().encode(self)
    }
}
