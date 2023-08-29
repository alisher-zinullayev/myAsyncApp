//
//  APIService.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 23.08.2023.
//

import UIKit

class APIService {
    
//    let baseURL = "https://"
    let baseURL = "https://images.unsplash.com/photo-1691512935129-5ab21146a1bc?ixid=M3w0OTEzMzh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY5MjcwNTU0MHw&ixlib=rb-4.0.3"
    
    func fetchImage() async throws -> UIImage {
        guard let imageURL = URL(string: baseURL) else {
            throw Errors.invalidURL
        }
        
        let(data, response) = try await URLSession.shared.data(from: imageURL)
        
        guard let image = UIImage(data: data) else {
            throw Errors.unableToConvertDataIntoImage
        }
        
        return image
    }
}

enum Errors: Error {
    case invalidURL
    case unableToConvertDataIntoImage
}
