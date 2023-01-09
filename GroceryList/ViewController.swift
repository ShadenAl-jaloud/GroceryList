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
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceboodButton: UIButton!
    @IBOutlet weak var errorMess: UILabel!
    
    //MARK: - Var
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMess.isHidden = true
        errorMess.textColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if handle != nil {return}
        handle = Auth.auth().addStateDidChangeListener { auth, user in
         
            if user != nil{
                let home = self.storyboard?.instantiateViewController(withIdentifier: "groceryView") as! GroceryList
                self.navigationItem.backBarButtonItem?.isHidden = true
                self.navigationController?.pushViewController(home, animated: true)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
      //  Auth.auth().removeStateDidChangeListener(handle!)
    }

    //MARK: - IBAction
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailField.text,
              email.isEmail(),
              let password = passField.text,
              password.count > 7
        else{
            errorMess.isHidden = false
            errorMess.text = "⚠ Email or password is wrong"
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
        
    }
    
    
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

