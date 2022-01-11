//
//  TagsVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 17/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView


class TagsVC: UIViewController {
    
    var tags: [String] = []
    
    // MARK: OUTLET
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        loaderView.startAnimating()
        PostAPI.getAllTags { tags in
            self.loaderView.stopAnimating()
            self.tags = tags
            self.tagsCollectionView.reloadData()
            
       
        }
    }
    


}

extension TagsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        
        let currentTag = tags[indexPath.row]
        cell.tagNameLabel.text = currentTag
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectdTag = tags[indexPath.row]
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostsVC") as! PostsVC
        vc.tag = selectdTag
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
