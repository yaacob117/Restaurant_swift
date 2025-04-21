//  MenuTableTableViewController.swift
//  Restaurant
//
//  Controlador de vista para la pantalla después de que se seleccionó la categoría

import UIKit

class MenuTableViewController: UITableViewController {
    /// El nombre de la categoría que deberíamos recibir de CategoryTableViewController
    var category: String!
    
    /// Array de elementos del menú que se mostrarán en la tabla
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // El título de la tabla es el nombre de la categoría en mayúsculas
        title = category.capitalized
        
        // Cargar el menú para una categoría dada
        MenuController.shared.fetchMenuItems(categoryName: category) { (menuItems) in
            // Si realmente obtuvimos los elementos del menú
            if let menuItems = menuItems {
                // Actualizar la interfaz
                self.updateUI(with: menuItems)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Ajustar las etiquetas de detalle (precio)
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // Ajustar las etiquetas de detalle (precio)
        fitDetailLabels()
    }
    
    /// Establecer la propiedad y actualizar la interfaz
    func updateUI(with menuItems: [MenuItem]) {
        // Tenemos que volver a la cola principal desde la cola de fondo donde se ejecutan las solicitudes de red
        DispatchQueue.main.async {
            // Recordar los elementos del menú para mostrarlos en la tabla
            self.menuItems = menuItems
            
            // Recargar la tabla
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }

    // MARK: - Fuente de datos de la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Solo hay una sección
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // El número de celdas es igual al tamaño del array de elementos del menú
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizar la celda prototipo de la lista del menú
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // Configurar la celda con los datos de la lista del menú
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configurar la celda de la tabla con los datos de la lista del menú
    /// - Parámetros:
    ///     - cell: La celda a configurar
    ///     - indexPath: Una ruta de índice que localiza una fila en tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // Obtener el elemento del menú necesario para la fila correspondiente de la tabla
        let menuItem = menuItems[indexPath.row]
        
        // La etiqueta izquierda de la celda debe mostrar el nombre del elemento
        cell.textLabel?.text = menuItem.name
        
        // La etiqueta derecha muestra el precio junto con el símbolo de la moneda
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        // Obtener la imagen del servidor
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // Verificar que la imagen se obtuvo correctamente
            guard let image = image else { return }
            
            // Volver al hilo principal después de la solicitud de red en segundo plano
            DispatchQueue.main.async {
                // Obtener la ruta de índice actual
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // Verificar si la celda aún no se recicló
                guard currentIndexPath == indexPath else { return }
                
                // Establecer la imagen en miniatura
                cell.imageView?.image = image
                
                // Ajustar la imagen a la celda
                self.fitImage(in: cell)
            }
        }
    }
    
    // Ajustar la altura de la celda para que las imágenes se vean mejor
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

    /// Pasa MenuItem a MenuItemDetailViewController antes del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Verifica que este segue sea de MenuTableViewController a MenuItemDetailViewController
        if segue.identifier == "MenuDetailSegue" {
            // Podemos convertir de manera segura a MenuItemDetailViewController
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            
            // La fila de la celda seleccionada es el índice para el array de menuItems
            let index = tableView.indexPathForSelectedRow!.row
            
            // Pasar el menuItem seleccionado al destino MenuItemDetailViewController
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }

}
