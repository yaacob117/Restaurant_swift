//
//  LocalData.swift
//  Restaurant
//

import Foundation

/// Usado para proporcionar datos locales con fines de depuración
struct LocalData {
    /// Usar datos locales en lugar del servidor remoto
    static let isLocal = true
    
    /// Lista de categorías que la aplicación debe devolver
    static let categories = [
        "appetizers",
        "entrees",
    ]
    
    static let menuItems = [
        MenuItem(
            id: 1,
            name: "Spaghetti and Meatballs",
            description: "Albóndigas sazonadas sobre espaguetis recién hechos. Servido con una robusta salsa de tomate.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "SpaghettiAndMeatballs")
        ),
        MenuItem(
            id: 2,
            name: "Margherita Pizza",
            description: "Salsa de tomate, mozzarella fresca, albahaca y aceite de oliva virgen extra.",
            price: 10,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "MargheritaPizza")
        ),
        MenuItem(
            id: 3,
            name: "Grilled Steelhead Trout Sandwich",
            description: "Trucha arcoíris del Pacífico a la parrilla con lechuga, tomate y cebolla roja.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "GrilledSteelheadTroutSandwich")
        ),
        MenuItem(
            id: 4,
            name: "Pesto Linguini",
            description: "Carne de res en rodajas guisada con cebollas amarillas y ajo en una salsa de vinagre y soja. Servido con arroz jazmín al vapor y verduras salteadas.",
            price: 9,
            category: "entrees",
            imageURL: URL(fileURLWithPath: "PestoLinguini")
        ),
        MenuItem(
            id: 5,
            name: "Chicken Noodle Soup",
            description: "Delicioso pollo cocido a fuego lento junto con cebollas amarillas, zanahorias, apio y hojas de laurel, en caldo de pollo.",
            price: 3,
            category: "appetizers",
            imageURL: URL(fileURLWithPath: "ChickenNoodleSoup")
        ),
        MenuItem(
            id: 6,
            name: "Italian Salad",
            description: "Ajo, cebollas rojas, tomates, champiñones y aceitunas sobre lechuga romana.",
            price: 5,
            category: "appetizers",
            imageURL: URL(fileURLWithPath: "ItalianSalad")
        ),
    ]
}
