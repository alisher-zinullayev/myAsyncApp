//
//  NetworkServiceWithAsync.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 22.08.2023.
//

import Foundation

class NetworkServiceWithAsync {
    
    static let shared = NetworkServiceWithAsync(); private init() { }
    
    private func createURL() -> URL? {
        let tunnel = "https://"
        let server = "api.unsplash.com/photos/?"
        let id = "client_id=un0STNzoCb3-9FrlA09e5FmOL_TpWpBjOHBdk5DIKCY"
        let params = ""
        let urlStr = tunnel + server + id + params
        
        let url = URL(string: urlStr)
        return url
    }
    
    func fetchData() async throws -> [Image] {
        guard let url = createURL() else { throw NetworkingError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode([Image].self, from: data)
        return result
    }
}

enum NetworkingError: Error {
    case badURL, badRequest, badResponse, invalidData
}
