//
//  ProductViewController.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/18.
//

import UIKit

// MARK: - StoryboardInstantiable

extension ProductListViewController: StoryboardInstantiable {}


/// 產品清單列表
class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var productList: [Product] = []
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegister()
        setupTableView()
        
        navigationController?.navigationBar.isHidden = false
        
    }
    
    
    private func setupRegister() {
        let nib = UINib(nibName: ProductListTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductListTableViewCell.nibName)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func set(productList: [Product]) {
        self.productList = productList
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    
}


// MARK: - UITableViewDelegate

extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}


// MARK: - UITableViewDataSource

extension ProductListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.isEmpty ? 0 : self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.nibName, for: indexPath) as! ProductListTableViewCell
        let product = self.productList[indexPath.row]
        
        cell.set(info: product)
        
        
        return cell
    }
}
