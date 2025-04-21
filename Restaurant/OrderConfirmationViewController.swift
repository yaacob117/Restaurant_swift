//  OrderConfirmationViewController.swift
//  Restaurant
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    /// Etiqueta con la información del tiempo restante
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    /// Tiempo restante en minutos
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Verificar si se necesita una "s" al final para plural
        let s = minutes! == 1 ? "" : "s"

        // Mensaje al usuario con el tiempo restante
        timeRemainingLabel.text = "¡Gracias por tu pedido! El tiempo de espera es aproximadamente de \(minutes!) minuto\(s)."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Liberar cualquier recurso que pueda ser recreado.
    }
    

    /*
    // MARK: - Navegación

    // En una aplicación basada en storyboard, a menudo querrás hacer una pequeña preparación antes de la navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Obtener el nuevo controlador de vista usando segue.destinationViewController.
        // Pasar el objeto seleccionado al nuevo controlador de vista.
    }
    */
}
