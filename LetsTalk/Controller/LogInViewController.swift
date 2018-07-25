//
//  LogInViewController.swift
//  LetsTalk
//
//  Created by Anand Nigam on 23/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInPressed(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error ) in
            if error != nil {
                print("Problem in logging in \(error!)")
            }
            else {
                print("\(user!) logged in")
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
