//  MenuController.swift
//  Restaurant

import UIKit

class MenuController {
    static let shared = MenuController()
    let baseURL = URL(string: "http://oracle.getoutfit.co:8090/")!

    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        if LocalData.esLocal {
            completion(LocalData.categorias)
            return
        }

        let categoryURL = baseURL.appendingPathComponent("categories")

        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
            if let data = data,
               let jsonDictionary = ((try? JSONSerialization.jsonObject(with: data) as? [String: Any]) as [String: Any]??),
               let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }

    func fetchMenuItems(categoryName: String = "", completion: @escaping ([MenuItem]?) -> Void) {
        if LocalData.esLocal {
            completion(LocalData.menuItems.filter { $0.category == categoryName || categoryName.isEmpty })
            return
        }

        let initialMenuURL = baseURL.appendingPathComponent("menu")

        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!

        if categoryName != "" {
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        }

        let menuURL = components.url!

        let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }

    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        if LocalData.esLocal {
            completion(5 * menuIds.count)
            return
        }

        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }

    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if LocalData.esLocal {
            completion(UIImage(named: url.relativeString))
            return
        }

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        components.host = baseURL.host

        guard let url = components.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}
