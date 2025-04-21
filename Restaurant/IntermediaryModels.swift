//
//  ModelosIntermedios.swift
//  Restaurant
//

// Corresponde a las claves devueltas por la API bajo categorías
struct Categorías: Codable {
    let categorías: [String]
}

struct TiempoPreparación: Codable {
    let tiempo: Int
    
    enum CodingKeys: String, CodingKey {
        case tiempo = "preparation_time"
    }
}
