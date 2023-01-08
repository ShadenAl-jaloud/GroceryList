//
//  ViewController.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var FaceboodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
}

