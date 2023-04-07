//
//  CartViewController.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.hidesBackButton = true
        let rightButton = UIBarButtonItem(title: "Kapat", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissPage))
        let leftButton = UIBarButtonItem(title: "Sil", style: UIBarButtonItem.Style.plain, target: self, action: #selector(emptyCart))
        
        leftButton.tintColor = .red
        rightButton.tintColor = .systemBlue
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    
    @objc func dismissPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func emptyCart() {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // geçici
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! FoodTableViewCell
        return cell
    }
    
}
