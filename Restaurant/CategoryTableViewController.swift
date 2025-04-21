//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Controlador de vista para la primera pantalla de la aplicación — categorías del menú

import UIKit

class CategoryTableViewController: UITableViewController {
    /// Nombres de las categorías del menú
    var categories = [String]()
    
    /// Array de elementos del menú que se obtendrán del servidor
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cargar el menú para todas las categorías
        MenuController.shared.fetchMenuItems() { (menuItems) in
            // si realmente obtuvimos los elementos del menú
            if let menuItems = menuItems {
                // componer la lista de categorías
                for item in menuItems {
                    // obtener la categoría del elemento
                    let category = item.category
                    
                    // agregar la categoría solo si no se agregó antes
                    if !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                
                // recordar la lista de elementos
                self.menuItems = menuItems
                
                // actualizar la tabla con categorías
                self.updateUI(with: self.categories)
            }
        }
    }
    
    /// Actualizar la tabla de categorías
    /// - parámetros:
    ///     - categories: Array de categorías para mostrar
    func updateUI(with categories: [String]) {
        // dado que las solicitudes de red se llaman en un hilo de fondo, necesitamos volver al hilo principal para actualizar la interfaz de usuario inmediatamente
        DispatchQueue.main.async {
            // recordar la lista de categorías para mostrar en la tabla
            self.categories = categories
            
            // recargar la tabla de categorías
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }

    // MARK: - Fuente de datos de la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Solo hay una sección: la lista de categorías
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // el número de secciones es igual al número de categorías que tenemos
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reutilizar una celda prototipo de categoría
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

        // Configurar la celda...
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configurar la celda de la tabla con datos de categoría
    /// - parámetros:
    ///     - cell: La celda a configurar
    ///     - indexPath: Una ruta de índice que localiza una fila en tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // obtener el nombre de la categoría
        let categoryString = categories[indexPath.row]
        
        // asegurarse de que esté en mayúsculas para limpiar la apariencia de las categorías
        cell.textLabel?.text = categoryString.capitalized
        
        // encontrar el primer elemento en la categoría para obtener la imagen
        guard let menuItem = menuItems.first(where: { item in
            return item.category == categoryString
        }) else { return }
        
        // obtener la imagen del servidor
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // verificar que la imagen se obtuvo correctamente
            guard let image = image else { return }
            
            // volver al hilo principal después de la solicitud de red en segundo plano
            DispatchQueue.main.async {
                // obtener la ruta de índice actual
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // verificar si la celda aún no se recicló
                guard currentIndexPath == indexPath else { return }
                
                // establecer la imagen en miniatura
                cell.imageView?.image = image
                
                // ajustar la imagen a la celda
                self.fitImage(in: cell)
            }
        }
    }

    // ajustar la altura de la celda para que las imágenes se vean mejor
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    /*
    // Anular para admitir la edición condicional de la vista de tabla.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Devuelve false si no deseas que el elemento especificado sea editable.
        return true
    }
    */

    /*
    // Anular para admitir la edición de la vista de tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Eliminar la fila de la fuente de datos
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Crear una nueva instancia de la clase apropiada, insertarla en el array y agregar una nueva fila a la vista de tabla
        }    
    }
    */

    /*
    // Anular para admitir la reorganización de la vista de tabla.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Anular para admitir la reorganización condicional de la vista de tabla.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Devuelve false si no deseas que el elemento sea reordenable.
        return true
    }
    */

    // MARK: - Navegación

    // Necesitamos pasar el nombre de la categoría elegida antes de mostrar el menú de la categoría
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // asegurarse de que el segue sea de categoría a controladores de vista de tabla de menú
        if segue.identifier == "MenuSegue" {
            // podemos convertir de manera segura a MenuTableViewController
            let menuTableViewController = segue.destination as! MenuTableViewController
            
            // el índice en el array de categorías es igual al número de fila seleccionada en la tabla
            let index = tableView.indexPathForSelectedRow!.row
            
            // almacenar el nombre de la categoría en el controlador de vista de tabla de menú de destino
            menuTableViewController.category = categories[index]
        }
    }

}
