//
//  Images.swift
//  MyApp
//
//  Created by Alisher Zinullayev on 20.08.2023.
//

import Foundation

struct Image: Codable {
    let id: String
    let urls: ImageURLs
    let alt_description: String?
}

struct ImageURLs: Codable {
    let regular: String
}
