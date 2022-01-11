//
//  CommentCell.swift
//  FinalProject
//
//  Created by Amani Atiah on 10/05/1443 AH.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentMessageLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
