//
//  CartViewController.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewProtocol_Add, TableViewProtocol_Remove {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var foodListFromApi_CV = [FoodModel]()
    var cartArray = [FoodModel]()
    let vm = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartArray = foodListFromApi_CV.filter { $0.currentCount != 0 }
        setupViews()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.hidesBackButton = true
        let rightButton = UIBarButtonItem(title: "Kapat", style: UIBarButtonItem.Style.plain, target: self, action: #selector(returnHomeScreen))
        let leftButton = UIBarButtonItem(title: "Sil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(emptyCart))
        
        leftButton.tintColor = .red
        rightButton.tintColor = .systemBlue
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
        
        totalPriceLabel.text = "Toplam : ₺\(Total.getPrice())"
    }
    
    @objc func returnHomeScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func emptyCart() {
        
        if cartArray.count != 0 {
            let alert = UIAlertController(title: "Onayla", message: "Bu işlem geri alınamaz", preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "Sil", style: UIAlertAction.Style.destructive) {UIAlertAction in
                
                self.vm.resetCurrentCounts(dataStr: self.cartArray)
                Total.resetPrice()
                self.cartArray.removeAll()
                
                self.tableView.reloadData()
                self.totalPriceLabel.text = "Toplam : ₺\(Total.getPrice())"
                
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)

            let closeButton = UIAlertAction(title: "Vazgeç", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(closeButton)

            self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: "Sepet zaten boş", width: 150)
        }
    }
    
    func increaseCart(indexPath: IndexPath) {
        
        let product = cartArray[indexPath.row]
        
        if product.currentCount < product.stock {
            product.increaseCurrentCount()
            Total.increaseTotalPrice(d: product.price)
            totalPriceLabel.text = "Toplam : ₺\( Total.getPrice() )"
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            self.showToast(message: "Maksimum \(product.name) stoğuna ulaşıldı", width: 300)
        }
    }
    
    func decreaseCart(indexPath: IndexPath) {
        
        let product = cartArray[indexPath.row]
        product.decreaseCurrentCount()
        Total.decreaseTotalPrice(d: product.price)
        
        if product.currentCount == 0 {
            cartArray.remove(at: indexPath.row)
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        self.totalPriceLabel.text = "Toplam : ₺\( Total.getPrice() )"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! FoodTableViewCell
        cell.cellProtocol_Add = self
        cell.cellProtocol_Minus = self
        cell.indexPath = indexPath
        
        cell.tableViewNameLabel.text = cartArray[indexPath.row].name
        cell.tableViewPriceLabel.text = "\(cartArray[indexPath.row].price) ₺"
        cell.tableViewCountLabel.text = String(cartArray[indexPath.row].currentCount)
        
        if cartArray[indexPath.row].currentCount == 0 {
            cartArray.remove(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        DispatchQueue.global().async {
            let imageData = try! Data(contentsOf: URL(string: "\(self.cartArray[indexPath.row].imageUrl)")!)
            DispatchQueue.main.async {
                cell.tableViewImageView.image = UIImage(data: imageData)
            }
        }
    
        return cell
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if cartArray.isEmpty {
            let alert = UIAlertController(title: "Sepet boş", message: "Sepette herhangi bir ürün yok", preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default) {UIAlertAction in
                
            }
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            vm.sendProducts(dataStr: cartArray) { result in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: result.message, message: "Sipariş ID: \(result.orderID)", preferredStyle: UIAlertController.Style.alert)
                    
                    let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default) {UIAlertAction in
                        self.vm.resetCurrentCounts(dataStr: self.cartArray)
                        Total.resetPrice()
                        self.cartArray.removeAll()
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
