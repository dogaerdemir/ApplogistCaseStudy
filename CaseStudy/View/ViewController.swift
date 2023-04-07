//
//  ViewController.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var foodList = [FoodModel]()
    let vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        vm.fetchDataFromAPI { completion in
            self.foodList = completion
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupViews() {
        
        let image = UIImage(systemName: "basket")
        let cartButton = UIBarButtonItem(image: image, style:.done, target: self, action: #selector(goToCart))
        self.navigationItem.rightBarButtonItem = cartButton
        
        let tasarim : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let ekranGenislik = self.collectionView.frame.size.width
        let hucreGenislik = (ekranGenislik - 30) / 2
        
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 5
        tasarim.minimumLineSpacing = 50
        tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik * 1.1)
        
        collectionView.collectionViewLayout = tasarim
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @objc func goToCart() {
        performSegue(withIdentifier: "toCartVC", sender: nil)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FoodCollectionViewCell
        
        
        cell.productLabel.text = foodList[indexPath.row].name
        cell.priceLabel.text = "\(foodList[indexPath.row].price) \(foodList[indexPath.row].currency)"
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: "\(self.foodList[indexPath.row].imageUrl)")!)
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
}

