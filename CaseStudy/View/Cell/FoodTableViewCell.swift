//
//  FoodTableViewCell.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit

protocol TableViewProtocol_Add {
    func increaseCart(indexPath : IndexPath)
}

protocol TableViewProtocol_Remove {
    func decreaseCart(indexPath : IndexPath)
}

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewImageView: UIImageView!
    @IBOutlet weak var tableViewNameLabel: UILabel!
    @IBOutlet weak var tableViewPlusButton: UIButton!
    @IBOutlet weak var tableViewMinusButton: UIButton!
    @IBOutlet weak var tableViewCountLabel: UILabel!
    @IBOutlet weak var tableViewPriceLabel: UILabel!
    
    var cellProtocol_Add : TableViewProtocol_Add?
    var cellProtocol_Minus : TableViewProtocol_Remove?
    var indexPath : IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.tableViewImageView.image = nil
    }
    
    @IBAction func minusButtonClicked(_ sender: Any) {
        cellProtocol_Minus?.decreaseCart(indexPath: indexPath!)
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        cellProtocol_Add?.increaseCart(indexPath: indexPath!)
    }
}
