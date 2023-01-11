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
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      if handle != nil {return}
            handle = Auth.auth().addStateDidChangeListener { auth, user in

                if user != nil{
                    OnlineModel.currenUser = user?.uid
                    guard let userId = user?.uid else { return }
                    OnlineModel.shared.updateState(id: userId, state: "online")

                    let home = self.storyboard?.instantiateViewController(withIdentifier: "groceryView") as! GroceryList
                    self.navigationItem.backBarButtonItem?.isHidden = true
                    self.navigationController?.pushViewController(home, animated: true)
                }
            }
            return
        
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
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            if err == nil {
                self.handle = Auth.auth().addStateDidChangeListener { auth, user in
                    guard let userId = user?.uid else { return }
                    OnlineModel.shared.updateState(id: userId, state: "online")
                }
                let story = UIStoryboard(name: "Main", bundle: nil)
                let home = story.instantiateViewController(withIdentifier: "groceryView") as! GroceryList
                self.navigationController?.pushViewController(home, animated: true)
            }
        }
         
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
        print("facebook cliked")
    }
    
}

