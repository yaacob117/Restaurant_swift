//
//  MenuItem.swift
//  Restaurant

import Foundation

// Las propiedades corresponden a las claves enumeradas en la API
struct MenuItem: Codable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case category
        case imageURL = "image_url"
    }
}

// La clave principal devuelta por la API se llama items
struct MenuItems: Codable {
    let items: [MenuItem]
}
