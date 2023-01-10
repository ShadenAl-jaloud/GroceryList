//
//  AppDelegate.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var handle: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
         /*handle = Auth.auth().addStateDidChangeListener { auth, user in
             
             let SB = UIStoryboard(name: "Main", bundle: nil)

             if user != nil{
                 guard let userId = user?.uid else { return }
                 OnlineModel.shared.updateState(id: userId, state: "online")

                 let home = SB.instantiateViewController(withIdentifier: "groceryView") as! GroceryList
                 let homeView = UINavigationController(rootViewController: home)
                 homeView.modalPresentationStyle = .fullScreen
                 self.window?.rootViewController = homeView
                 
             } else {
                 let login = SB.instantiateViewController(withIdentifier: "loginView") as! ViewController
             }
         }*/
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

