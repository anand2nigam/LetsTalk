//
//  ChatViewController.swift
//  LetsTalk
//
//  Created by Anand Nigam on 23/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var messageTableView: UITableView!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
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
        
        // Registering CustomMessageConfigTableViewCell.xib file to be used
        messageTableView.register(UINib(nibName: "CustomMessageConfigTableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Call to method to configure the cell height accordingly
        configureTableViewCellHeight()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initiate the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageConfigTableViewCell
        
        //configureTableViewCellHeight()
        
        // Configure the cell
        let messageArray = ["First message", "Second Message. I am trying to find a way to move over the things so that i can do my work with more efficiency and productivity. By the way i am going to do something very big in my life in order to pursue all my dreams", "Third Message"]
        
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
