//
//  messageTableViewCell.swift
//  Messenger
//
//  Created by Field Employee on 11/14/20.
//

import UIKit

class messageTableViewCell: UITableViewCell {

    @IBOutlet weak var textMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
