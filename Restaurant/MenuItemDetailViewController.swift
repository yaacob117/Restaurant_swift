//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Controlador de vista para los detalles de un alimento en particular

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    /// MenuItem recibido de MenuTableViewController
    var menuItem: MenuItem!
    
    /// Delegado para notificar que se presionó el botón Agregar al Pedido
    var delegate: AddToOrderDelegate?
    
    /// Nombre del alimento
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Imagen del alimento
    @IBOutlet weak var imageView: UIImageView!
    
    /// Precio del alimento
    @IBOutlet weak var priceLabel: UILabel!
    
    /// Descripción del alimento
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// Botón para ordenar el alimento
    @IBOutlet weak var addToOrderButton: UIButton!
    
    /// Acción llamada cuando el usuario presiona el botón Agregar al Pedido
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        // Animación rápida de rebote después de presionar el botón
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        // Notificar al delegado que el elemento fue agregado al pedido
        delegate?.added(menuItem: menuItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Actualizar la pantalla con los valores de menuItem
        updateUI()
        
        // Configurar el delegado
        setupDelegate()
    }
    
    /// Actualizar las propiedades de los outlets para que coincidan con los valores de menuItem
    func updateUI() {
        // El nombre del alimento
        titleLabel.text = menuItem.name
        
        // Precio del alimento
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        
        // Descripción detallada del alimento
        descriptionLabel.text = menuItem.description
        
        // Hacer que las esquinas del botón sean redondeadas
        addToOrderButton.layer.cornerRadius = 5
        
        // Obtener la imagen para el elemento del menú
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // Verificar que la imagen se haya cargado
            guard let image = image else { return }
            
            // Asignar la imagen a la vista de imagen en el hilo principal
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    /// Configurar el delegado para que el elemento seleccionado se pase al pedido más tarde
    func setupDelegate() {
        // Encontrar el controlador de vista de tabla de pedidos a través del controlador de navegación
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
            let orderTableViewController = navController.viewControllers.first as? OrderTableViewController {
            delegate = orderTableViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }

    /*
    // MARK: - Navegación

    // En un storyboard basado en la aplicación, a menudo querrás hacer una pequeña preparación antes de la navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Obtener el nuevo controlador de vista usando segue.destinationViewController.
        // Pasar el objeto seleccionado al nuevo controlador de vista.
    }
    */

}
