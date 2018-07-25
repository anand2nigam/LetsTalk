//
//  CustomMessageConfigTableViewCell.swift
//  LetsTalk
//
//  Created by Anand Nigam on 24/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit

class CustomMessageConfigTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageBody: UILabel!
    
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var senderUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
}
