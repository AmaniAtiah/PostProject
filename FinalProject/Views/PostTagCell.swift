//
//  PostTagCell.swift
//  FinalProject
//
//  Created by Amani Atiah on 18/05/1443 AH.
//

import UIKit

class PostTagCell: UICollectionViewCell {
  
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 8
        }
    }
    
}
