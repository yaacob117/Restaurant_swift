//
//  AddToOrderDelegate.swift
//  Restaurant
//  Protocolo para agregar elementos al pedido

protocol AddToOrderDelegate {
    /// Llamado cuando se agrega un elemento del menú
    func added(menuItem: MenuItem)
}
