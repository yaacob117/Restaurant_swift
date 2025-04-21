//
//  AppDelegate.swift
//  Restaurant


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // directorio temporal para una caché
        let directorioTemporal = NSTemporaryDirectory()
        
        // crear una caché usando 25 megabytes de memoria y 50 megabytes de disco
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Enviado cuando la aplicación está a punto de pasar de activa a inactiva. Esto puede ocurrir por ciertos tipos de interrupciones temporales (como una llamada telefónica entrante o un mensaje SMS) o cuando el usuario cierra la aplicación y comienza la transición al estado de fondo.
        // Usa este método para pausar tareas en curso, deshabilitar temporizadores e invalidar las devoluciones de llamada de renderizado gráfico. Los juegos deben usar este método para pausar el juego.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Usa este método para liberar recursos compartidos, guardar datos del usuario, invalidar temporizadores y almacenar suficiente información del estado de la aplicación para restaurarla a su estado actual en caso de que se termine más tarde.
        // Si tu aplicación admite ejecución en segundo plano, este método se llama en lugar de applicationWillTerminate: cuando el usuario cierra la aplicación.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Llamado como parte de la transición del estado de fondo al estado activo; aquí puedes deshacer muchos de los cambios realizados al entrar en el fondo.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Reinicia cualquier tarea que se haya pausado (o que aún no haya comenzado) mientras la aplicación estaba inactiva. Si la aplicación estaba previamente en segundo plano, opcionalmente actualiza la interfaz de usuario.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Llamado cuando la aplicación está a punto de terminar. Guarda datos si es apropiado. Consulta también applicationDidEnterBackground:.
    }


}

