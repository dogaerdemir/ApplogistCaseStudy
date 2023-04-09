//
//  ViewController.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CollectionViewProtocol_Add, CollectionViewProtocol_Remove{

    @IBOutlet weak var collectionView: UICollectionView!
    var navBarLabel = UILabel()
    
    var foodListFromApi = [FoodModel]()
    let vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        vm.fetchDataFromAPI { completion in
            self.foodListFromApi = completion
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTitleOnNavBar(title: String(foodListFromApi.filter { $0.currentCount != 0 }.count))
        collectionView.reloadData()
    }
    
    func setupViews() {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "basket"), for: .normal)
        button.addTarget(self, action: #selector((goToCart)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)

        navBarLabel = UILabel(frame: CGRect(x: 15, y: -5, width: 50, height: 20))// set position of label
        navBarLabel.font = UIFont(name: "Arial-BoldMT", size: 16)// add font and size of label
        navBarLabel.text = String(foodListFromApi.filter { $0.currentCount != 0 }.count)
        navBarLabel.textAlignment = .center
        navBarLabel.textColor = UIColor.blue
        navBarLabel.backgroundColor =   UIColor.clear
        
        button.addSubview(navBarLabel)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
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
    
    func updateTitleOnNavBar(title: String) {
        navBarLabel.text = title
    }
    
    
    @objc func goToCart() {
        performSegue(withIdentifier: "toCartVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCartVC" {
            let destination = segue.destination as! CartViewController
            
            destination.foodListFromApi_CV = foodListFromApi
        }
    }
    
    func increaseCart(indexPath: IndexPath) {
        let urun = foodListFromApi[indexPath.row]
        
        if urun.currentCount < urun.stock {
            urun.increaseCurrentCount()
            updateTitleOnNavBar(title: String(foodListFromApi.filter { $0.currentCount != 0 }.count))
            Total.increaseTotalPrice(d:urun.price)
            collectionView.reloadItems(at: [indexPath])
        } else {
            self.showToast(message: "Maksimum \(urun.name) stoğuna ulaşıldı", width: 300)
        }
    }
    
    func decreaseCart(indexPath: IndexPath) {
        let urun = foodListFromApi[indexPath.row]
        urun.decreaseCurrentCount()
        updateTitleOnNavBar(title: String(foodListFromApi.filter { $0.currentCount != 0 }.count))
        collectionView.reloadItems(at: [indexPath])
        Total.decreaseTotalPrice(d: urun.price)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodListFromApi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.cellProtocol_Add = self
        cell.cellProtocol_Remove = self
        cell.indexPath = indexPath
        cell.minusButton.isHidden = true
        cell.countLabel.isHidden = true
        
        cell.productLabel.text = foodListFromApi[indexPath.row].name
        cell.priceLabel.text = "\(foodListFromApi[indexPath.row].price) \(foodListFromApi[indexPath.row].currency)"
        
        cell.countLabel.text = "\(foodListFromApi[indexPath.row].currentCount)"
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: "\(self.foodListFromApi[indexPath.row].imageUrl)")!)
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        if foodListFromApi[indexPath.row].currentCount == 0 {
            cell.minusButton.isHidden = true
            cell.countLabel.isHidden = true
        }else {
            cell.minusButton.isHidden = false
            cell.countLabel.isHidden = false
        }
        
        return cell
    }
}


extension UIViewController {
    func showToast(message : String, width : CGFloat) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (width/2), y: self.view.frame.size.height-100, width: width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 13)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.5, delay: 2, options: .curveEaseOut, animations:{
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
