//
//  ViewController.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceboodButton: UIButton!
    @IBOutlet weak var errorMes: UILabel!
    
    //MARK: - Var
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMes.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if handle != nil {return}
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.dismiss(animated: true)
            if user != nil{
             //let gr
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
      //  Auth.auth().removeStateDidChangeListener(handle!)
    }

    //MARK: - IBAction
    @IBAction func toSignUpScreen(_ sender: UIButton) {
        
        let signUp = storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUp
        navigationItem.backButtonTitle = "Login"
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        print("google cliked")
    }
    
    
    @IBAction func facebookLogin(_ sender: UIButton) {
     /*
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
         
            loginManager.logOut()
            
        } else {
            
            loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    return
                }
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
            
                Profile.loadCurrentProfile { (profile, error) in
                  
                }
            }
        }*/
    }
    
}

