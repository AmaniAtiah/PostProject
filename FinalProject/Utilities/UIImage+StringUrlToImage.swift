//
//  UIImage+StringUrlToImage.swift
//  FinalProject
//
//  Created by Amani Atiah on 11/05/1443 AH.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromStringUrl(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            if let imageData = try? Data(contentsOf: url) {
                self.image = UIImage(data: imageData)
                
            }
        }
    }
    
    func makeCirclerImage(){
        self.layer.cornerRadius = self.frame.width / 2
    }
}
 
