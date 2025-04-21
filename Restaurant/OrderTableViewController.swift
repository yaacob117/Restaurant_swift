//
//  OrderTableViewController.swift
//  Restaurant
//  Controlador de vista para la lista de pedidos

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    
    /// La lista de elementos pedidos
    var menuItems = [MenuItem]()
    
    /// Minutos restantes para el pedido
    var orderMinutes = 0

    /// Alerta al usuario que su pedido será enviado si continúa
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        // calcular el costo total del pedido
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        // formatear el precio total del pedido
        let formattedOrder = String(format: "$%2.f", orderTotal)
        
        // preparar una alerta para el usuario
        let alert = UIAlertController(
            title: "Confirmar Pedido",
            message: "Estás a punto de enviar tu pedido con un total de \(formattedOrder)",
            preferredStyle: .alert
        )
        
        // agregar acción de enviar pedido al confirmar
        alert.addAction(UIAlertAction(title: "Enviar", style: .default) { action in
            self.uploadOrder()
        })
        
        // agregar acción de cancelar al descartar
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        // presentar la alerta al usuario sobre el envío del pedido
        present(alert, animated: true, completion: nil)
    }
    
    /// Regresar a la lista de pedidos cuando se presiona el botón de descartar
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        // verificar que efectivamente estamos descartando la pantalla de confirmación
        if segue.identifier == "DismissConfirmation" {
            // limpiar los elementos del menú del pedido
            menuItems.removeAll()
            
            // recargar la tabla para mostrar la lista vacía
            tableView.reloadData()
            
            // actualizar el número de elementos en la lista de pedidos
            updateBadgeNumber()
        }
    }
    
    /// Realizar la solicitud usando el método submitOrder() definido en MenuController
    func uploadOrder() {
        // crear un array de IDs de menú seleccionados para el pedido
        let menuIds = menuItems.map { $0.id }
        
        // llamar a submitOrder() desde MenuController
        MenuController.shared.submitOrder(menuIds: menuIds) { minutes in
            // regresar a la cola principal ya que las solicitudes de red se ejecutan en segundo plano
            DispatchQueue.main.async {
                // verificar si los minutos se devolvieron correctamente
                if let minutes = minutes {
                    // recordar los minutos restantes
                    self.orderMinutes = minutes
                    
                    // realizar el segue a la pantalla de confirmación
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Mostrar un botón de Editar en la barra de navegación para este controlador de vista.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ajustar las etiquetas de detalle (precio)
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // ajustar las etiquetas de detalle (precio)
        fitDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }

    // MARK: - Fuente de datos de la tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // el número de filas es igual al número de elementos en el array menuItems
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // reutilizar la celda prototipo de la lista de pedidos
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        
        // configurar la celda con los datos de la lista del menú
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    /// Configurar la celda con los datos de la lista de pedidos
    /// - parámetros:
    ///     - cell: La celda a configurar
    ///     - indexPath: Una ruta de índice que localiza una fila en tableView
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // obtener el elemento del menú necesario para la fila correspondiente de la tabla
        let menuItem = menuItems[indexPath.row]
        
        // la etiqueta izquierda de la celda debe mostrar el nombre del elemento
        cell.textLabel?.text = menuItem.name
        
        // la etiqueta derecha muestra el precio junto con el símbolo de la moneda
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        // obtener la imagen del servidor
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // verificar que la imagen se obtuvo correctamente
            guard let image = image else { return }
            
            // regresar al hilo principal después de la solicitud de red en segundo plano
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

    // Confirmar qué elementos (todos) admiten la edición (eliminación de elementos del menú) de la vista de tabla de pedidos.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: Bool) -> Bool {
        // Todos los elementos son editables (eliminables)
        return true
    }

    // Admitir la edición de la vista de tabla de pedidos.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Eliminar el elemento de la lista de pedidos
            menuItems.remove(at: indexPath.row)
            
            // Eliminar la fila de la tabla
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Actualizar el número de elementos en la insignia
            updateBadgeNumber()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // ajustar la etiqueta de detalle (precio) en la celda
        fitDetailLabel(in: cell)
    }

    // MARK: - Navegación

    /// Pasar los minutos del pedido antes del segue a la página de confirmación del pedido
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // verificar que efectivamente estamos realizando el segue de confirmación del pedido
        if segue.identifier == "ConfirmationSegue" {
            // obtener el nuevo controlador de vista usando segue.destinationViewController.
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            
            // pasar los minutos restantes al controlador de vista de destino
            orderConfirmationViewController.minutes = orderMinutes
        }
        // Pasar el objeto seleccionado al nuevo controlador de vista.
    }
    
    /// Llamado cuando se agrega un elemento del menú
    func added(menuItem: MenuItem) {
        // agregar el elemento del menú al array menuItems
        menuItems.append(menuItem)
        
        // obtener el número total de elementos del menú
        let count = menuItems.count
        
        // calcular la ruta de índice para la última fila
        let indexPath = IndexPath(row: count - 1, section: 0)
        
        // insertar la fila del elemento del menú al final de la tabla de pedidos
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // actualizar la insignia con el número de elementos en el pedido
        updateBadgeNumber()
    }
    
    /// Actualizar el valor de la insignia de la pestaña de pedidos para que coincida con el número de elementos en el pedido
    func updateBadgeNumber() {
        // obtener el número de elementos en el pedido
        let badgeValue = 0 < menuItems.count ? "\(menuItems.count)" : nil
        
        // asignar el valor de la insignia a la pestaña de pedidos
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
}
