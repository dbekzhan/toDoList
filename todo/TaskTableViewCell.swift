//
//  TaskTableViewCell.swift
//  todo
//
//  Created by Dimash Bekzhan on 6/28/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var taskRef: Task!
    var delegate: TableViewCellDelegate!
    
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewLifeCategory: UIImageView!
    
    @IBOutlet weak var switchOutletState: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        taskRef.isDone = !taskRef.isDone
    }
    
    @objc func handleDoubleTap() {
        delegate.tableViewCell(doubleTapActionDelegatedFrom: self)
    }
    
}
