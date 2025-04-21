//
//  Controlador para la primera pantalla de la app — categorías del menú

import UIKit

class ControladorTablaCategorías: UITableViewController {
    /// Nombres de las categorías del menú
    var categorías = [String]()
    
    /// Array de elementos del menú que se obtendrán del servidor
    var elementosDelMenú = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cargar el menú para todas las categorías
        MenuController.shared.fetchMenuItems() { (items) in
            if let items = items {
                for item in items {
                    let categoría = item.category
                    if !self.categorías.contains(categoría) {
                        self.categorías.append(categoría)
                    }
                }
                self.elementosDelMenú = items
                self.actualizarInterfaz(con: self.categorías)
            }
        }
    }
    
    /// Actualizar la tabla de categorías
    /// - parámetros:
    ///     - categories: Array de categorías para mostrar
    func actualizarInterfaz(con categorías: [String]) {
        DispatchQueue.main.async {
            self.categorías = categorías
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }

    // MARK: - Fuente de datos de la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorías.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        configurar(celda: celda, en: indexPath)
        return celda
    }
    
    /// Configurar la celda de la tabla con datos de categoría
    /// - parámetros:
    ///     - cell: La celda a configurar
    ///     - indexPath: Una ruta de índice que localiza una fila en tableView
    func configurar(celda: UITableViewCell, en indexPath: IndexPath) {
        let nombreCategoría = categorías[indexPath.row]
        celda.textLabel?.text = nombreCategoría.capitalized

        guard let item = elementosDelMenú.first(where: { $0.category == nombreCategoría }) else { return }

        MenuController.shared.fetchImage(url: item.imageURL) { imagen in
            guard let imagen = imagen else { return }

            DispatchQueue.main.async {
                guard let índiceActual = self.tableView.indexPath(for: celda), índiceActual == indexPath else { return }
                celda.imageView?.image = imagen
                self.fitImage(in: celda)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Navegación

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let controladorMenú = segue.destination as! MenuTableViewController
            let índice = tableView.indexPathForSelectedRow!.row
            controladorMenú.category = categorías[índice]
        }
    }
}
