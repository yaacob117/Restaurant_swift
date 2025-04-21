//
//  IntermediaryModels.swift
//  Restaurant
//

// Corresponde a las claves devueltas por la API bajo categorías
struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
