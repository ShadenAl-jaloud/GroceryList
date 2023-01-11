//
//  memberCell.swift
//  GroceryList
//
//  Created by admin on 1/8/23.
//

import UIKit

class MemberCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
