//
//  FoodCollectionViewCell.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit

protocol CollectionViewProtocol_Add {
    func increaseCart(indexPath : IndexPath)
}

protocol CollectionViewProtocol_Remove {
    func decreaseCart(indexPath : IndexPath)
}

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var cellProtocol_Add : CollectionViewProtocol_Add?
    var cellProtocol_Remove : CollectionViewProtocol_Remove?
    var indexPath : IndexPath?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        cellProtocol_Add?.increaseCart(indexPath: indexPath!)
    }
    
    @IBAction func minusButtonClicked(_ sender: Any) {
        cellProtocol_Remove?.decreaseCart(indexPath: indexPath!)
    }
}
