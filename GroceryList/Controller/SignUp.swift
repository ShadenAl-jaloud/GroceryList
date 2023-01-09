//
//  SignUp.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit
import FirebaseAuth

class SignUp: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var errorMes: UILabel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMes.isHidden = true
    }
    
    
    //MARK: - IBAcion
    @IBAction func SignUpAction(_ sender: UIButton) {
        
            // signup error messages
            guard let useName = userNameField.text,
                  useName != ""
                else{
                errorMes.text = "⚠ Your name is empty"
                errorMes.isHidden = false
                return
            }
            guard emailField.isEmail(),
                  let email = emailField.text
                else{
                errorMes.text = "⚠ Invalid email"
                errorMes.isHidden = false
                return
            }
            
            guard let password = passField.text,
                  password.count > 7
            else{
                errorMes.text = "⚠ Password length most be 8 or more "
                errorMes.isHidden = false
                return
            }
            guard let confPass = confirmPassField.text,
                password == confPass
            else{
                errorMes.text = "⚠ Password NOT matched"
                errorMes.isHidden = false
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if  err != nil {
                    self.errorMes.isHidden = false
                    self.errorMes.text = "⚠ \(err!.localizedDescription)"
                }
                else{
                  // here I need to save the user info in the database 
                }
                    }
                    
            // back to login page
            self.navigationController?.popViewController(animated: true)
                
        }
    
}
