//
//  GroceryCell.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit

class GroceryCell: UITableViewCell {

    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
