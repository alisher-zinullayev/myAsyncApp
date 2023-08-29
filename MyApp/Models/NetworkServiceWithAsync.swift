//
//  NetworkServiceWithAsync.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 22.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol: AnyObject {
    func fetchRandomImage(count: Int) async throws -> [URL]?
    func fetchImage(url: URL) async throws -> UIImage?
}

let imageCache = NSCache<AnyObject, AnyObject>()

final class NetworkServiceWithAsync: UIImageView, NetworkingServiceProtocol {
    
    
    var imageNames: [String] = []
    
    func fetchRandomImage(count: Int) async throws -> [URL]? {
        guard var components = URLComponents(string: "https://api.unsplash.com/photos/") else {
            throw NetworkingError.badURL
        }
        // fiTKp11mPllXJJxErH2e_j4qFoOKmCL4mTFaJ_CmP8A
        // un0STNzoCb3-9FrlA09e5FmOL_TpWpBjOHBdk5DIKCY
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "fiTKp11mPllXJJxErH2e_j4qFoOKmCL4mTFaJ_CmP8A"),
            URLQueryItem(name: "count", value: "\(count)")
        ]

        guard let url = components.url else {
            throw NetworkingError.badURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let images = try JSONDecoder().decode([Image].self, from: data)
            let imageURLs = images.compactMap { URL(string: $0.urls.regular) }
            return imageURLs
        } catch {
            throw NetworkingError.invalidData
        }
    }
    
    func fetchImage(url: URL) async throws -> UIImage? {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            return imageFromCache
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = image
                }
                
                return image
            }
        } catch {
            print("Couldn't load image from url: \(url), error: \(error)")
        }
        
        return nil
    }
    
    func getDescriptions(completion: @escaping ([String]) -> Void) {
        let apiKey = "fiTKp11mPllXJJxErH2e_j4qFoOKmCL4mTFaJ_CmP8A"
        let count = 10
        let urlString = "https://api.unsplash.com/photos/?client_id=\(apiKey)&count=\(count)"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([Image].self, from: data)
                let descriptions = response.compactMap { image -> String? in
                    if let altDescription = image.alt_description {
                        return altDescription
                    } else {
                        return "Description not provided"
                    }
                }
                
                completion(descriptions)
            } catch {
                completion([])
            }
            
            
            
        }
        task.resume()
    }
}

enum NetworkingError: Error {
    case badURL, badRequest, badResponse, invalidData
}



