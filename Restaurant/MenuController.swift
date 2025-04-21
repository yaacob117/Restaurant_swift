//
//  MenuController.swift
//  Restaurant

import UIKit

// Controlador con todo el código de red
class MenuController {
    /// Usado para compartir MenuController entre todos los controladores de vista en la aplicación
    static let shared = MenuController()
    
    /// URL base donde deben ir todas las solicitudes. Cambia esto a tu propio servidor.
    /// La aplicación del servidor para macOS se puede descargar [aquí](https://www.dropbox.com/sh/bmbhzxqi1886kix/AABFwZJiMj_wxqaUphHFJh5ba?dl=1)
    let baseURL = URL(string: "http://oracle.getoutfit.co:8090/")!
    
    /// Ejecuta una solicitud GET para las categorías con /categories
    /// - parámetros:
    ///     - completion: El cierre que acepta el array de cadenas devuelto por JSON
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        
        // si los datos son locales, úsalos
        if LocalData.isLocal {
            completion(LocalData.categories)
            return
        }
        
        // URL completa para la solicitud de categorías es.../categories
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        // crea una tarea para la llamada de red para obtener la lista de categorías
        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
            // el endpoint /categories decodificado en un objeto Categories
            if let data = data,
                let jsonDictionary = ((try? JSONSerialization.jsonObject(with: data) as? [String:Any]) as [String : Any]??),
                let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        
        // comienza la llamada de red para obtener la lista de categorías
        task.resume()
    }
    
    /// Ejecuta una solicitud GET desde /menu con el parámetro de consulta — nombre de la categoría
    /// - parámetros:
    ///     - categoryName: El nombre de la categoría
    ///     - completion: El cierre que acepta el array de MenuItem devuelto por JSON
    func fetchMenuItems(categoryName: String = "", completion: @escaping([MenuItem]?) -> Void) {
        
        // si los datos son locales, úsalos
        if LocalData.isLocal {
            completion(LocalData.menuItems.filter { $0.category == categoryName || categoryName.isEmpty })
            return
        }
        
        // agrega /menu a la URL de la solicitud
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        // crea el componente category=<nombre de la categoría>
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        
        // agrega ?category=<nombre de la categoría> solo si categoryName no está vacío
        if categoryName != "" {
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        }
        
        // compone la URL completa .../menu?category=<nombre de la categoría>
        let menuURL = components.url!
        
        // crea una tarea para la llamada de red del menú de la categoría
        let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
            // datos de /menu convertidos en un array de objetos MenuItem
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        
        // comienza la llamada de red del menú de la categoría
        task.resume()
    }
    
    /// Ejecuta una solicitud POST a /order con el pedido del usuario
    /// - parámetros:
    ///     - menuIds: Array de los IDs de los platos en el pedido
    ///     - completion: Un cierre que toma el tiempo de preparación del pedido
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        
        // si los datos son locales, simula el tiempo de preparación
        if LocalData.isLocal {
            completion(5 * menuIds.count)
            return
        }
        
        // URL completa para publicar el pedido es .../order
        let orderURL = baseURL.appendingPathComponent("order")
        
        // crea una solicitud para publicar el pedido
        var request = URLRequest(url: orderURL)
        
        // modifica el método de la solicitud a POST
        request.httpMethod = "POST"
        
        // indica al servidor qué tipo de datos estamos enviando — JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // codifica el array de IDs de menú en JSON
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        // los datos para un POST deben almacenarse dentro del cuerpo de la solicitud
        request.httpBody = jsonData
        
        // crea una tarea para la llamada de red del pedido
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // POST a /order devuelve datos JSON que deben decodificarse en PreparationTime
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        
        // comienza la llamada de red del pedido
        task.resume()
    }
    
    /// Obtiene una imagen del servidor
    /// - parámetros:
    ///     - url: Una URL de imagen
    ///     - completion: Un manejador que recibe datos UIImage
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        // si los datos son locales, úsalos
        if LocalData.isLocal {
            completion(UIImage(named: url.relativeString))
            return
        }
        
        // construye componentes de URL desde la URL
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        // reemplaza el host por el host de la URL base
        components.host = baseURL.host
        
        // construye la nueva URL con el host reemplazado
        guard let url = components.url else { return }
        
        // crea una tarea para la llamada de URL de obtención de imagen
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            // verifica que los datos se devuelvan y la imagen sea válida
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        // comienza la llamada de red para obtener la imagen
        task.resume()
    }
}
