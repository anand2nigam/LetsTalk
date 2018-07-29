//
//  ChatViewController.swift
//  LetsTalk
//
//  Created by Anand Nigam on 23/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray: [Message] = [ Message]()
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK:- Sending Messages to the database
    
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
    
    // Mark:- Logging out the user

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show()
        
        do {
            try FIRAuth.auth()?.signOut()
            
            SVProgressHUD.dismiss()
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
        
        messageTableView.separatorStyle = .none
        
        retrieveMessages()
        
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
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUserName.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUserName.text == FIRAuth.auth()?.currentUser?.email as String? {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        // return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    // Method to configure TableViewCell height
    
    func configureTableViewCellHeight() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0

    }
    
    // MARK: - Retrieve Messages from the database
    
    func retrieveMessages() {
        let messageDB = FIRDatabase.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            print(text , sender)
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableViewCellHeight()
            self.messageTableView.reloadData()
        }
        
    }

}
