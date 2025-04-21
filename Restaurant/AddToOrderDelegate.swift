//
//  AddToOrderDelegate.swift
//  Restaurant
//  Protocolo para agregar elementos al pedido

protocol AgregarAlPedidoDelegado {
    /// Llamado cuando se agrega un elemento del menú
    func elementoAgregado(menuItem: MenuItem)
}
