//
//  TaskTableViewCell.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var switchOutletState: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        
    }
    
}
