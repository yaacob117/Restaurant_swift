//
//  UITableViewControllerExtension.swift
//  Restaurant

import UIKit

extension UITableViewController {
    /// Ajusta las etiquetas de detalle (precio) en las celdas visibles
    func fitDetailLabels() {
        // recorre la lista de celdas visibles
        for cell in tableView.visibleCells {
            fitDetailLabel(in: cell)
        }
    }
    
    /// Ajusta la etiqueta de detalle (precio) en una celda específica
    func fitDetailLabel(in cell: UITableViewCell) {        
        // obtiene la vista de imagen
        guard let imageView = cell.imageView else { return }
        
        // obtiene la etiqueta de texto principal
        guard let textLabel = cell.textLabel else { return }
        
        // obtiene la etiqueta de texto de detalle
        guard let detailTextLabel = cell.detailTextLabel else { return }
        
        // obtiene el ancho de la vista de imagen
        let imageWidth = imageView.frame.width
        
        // recuerda el ancho original de la etiqueta de texto principal
        let textWidth = textLabel.frame.width
        
        // recuerda el ancho original de la etiqueta de texto de detalle
        let detailWidth = detailTextLabel.frame.width
        
        // calcula el ancho total de la imagen y las dos etiquetas (puede ser menor que el ancho de la celda)
        let totalWidth = imageWidth + textWidth + detailWidth
        
        // ajusta la etiqueta de texto de detalle
        detailTextLabel.sizeToFit()
        
        // asegura que el ancho de la imagen no cambie
        imageView.frame.size.width = imageWidth
        
        // obtiene el nuevo ancho de la etiqueta de texto de detalle
        let newDetailWidth = detailTextLabel.frame.width
        
        // calcula el nuevo ancho de la etiqueta de texto principal basado en el ancho de la etiqueta de detalle
        let newTextWidth = totalWidth - imageWidth - newDetailWidth
        
        // si no se necesitan cambios, salir
        guard newTextWidth < textWidth else { return }
        
        // establece el nuevo ancho de la etiqueta de texto principal
        textLabel.frame.size.width = newTextWidth
        
        // ajusta el ancho con la nueva fuente
        textLabel.adjustsFontSizeToFitWidth = true
        
        // mueve el nuevo origen de la etiqueta de texto de detalle
        detailTextLabel.frame.origin.x -= newDetailWidth - detailWidth
    }
    
    /// Ajusta la imagen en una celda específica
    func fitImage(in cell: UITableViewCell) {
        // verifica si se puede obtener la vista de imagen
        guard let imageView = cell.imageView else { return }
        
        // recuerda el ancho anterior de la vista de imagen
        let oldWidth = imageView.frame.width
        
        // establece el tamaño de la vista de imagen
        imageView.frame.size = CGSize(width: 100, height: 100)
        
        // calcula el desplazamiento hacia la izquierda
        let leftShift = oldWidth - imageView.frame.width
        
        // obtiene la etiqueta de texto principal
        guard let textLabel = cell.textLabel else { return }

        // mueve la etiqueta hacia la izquierda
        textLabel.frame.origin.x -= leftShift        
    }
}
