//
//  ChatViewController.swift
//  LetsTalk
//
//  Created by Anand Nigam on 23/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var messageTableView: UITableView!


    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        // Creating our database in firebase for messages
        let messageDatabase = FIRDatabase.database().reference().child("Messages")
        // Creating a dictionary to save data in the database in which only the user id and the message is going to be saved
        let messageDictionary = ["Sender" : FIRAuth.auth()?.currentUser?.email , "MessageBody" : messageTextField.text]
        
        // To save our messages in the message database through a automatically generated identifier
        messageDatabase.childByAutoId().setValue(messageDictionary) {
            (error , reference) in
            if error != nil {
                print(error!)
            }
            else {
                print("Message Saved in the Database")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextField.text = ""
            }
        }
        
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch {
            print("An error occurred while signing out")
        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        // Registering CustomMessageConfigTableViewCell.xib file to be used
        messageTableView.register(UINib(nibName: "CustomMessageConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Call to method to configure the cell height accordingly
       configureTableViewCellHeight()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1.0) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    // MARK:- TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initiate the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageConfigTableViewCell
        
        //configureTableViewCellHeight()
        
        // Configure the cell
        let messageArray = ["First message", "Second Message.what is going on into the woods. I saw you hanging around with them. know your limits", "Third Message"]
        
        cell.messageBody.text = messageArray[indexPath.row]
        
        // return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // Method to configure TableViewCell height
    
    func configureTableViewCellHeight() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0

    }
    

}
