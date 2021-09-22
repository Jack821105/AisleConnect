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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    
    private func setupRegister() {
        //        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
    }

    
}


// MARK: - UITableViewDelegate

extension ProductListViewController: UITableViewDelegate {}


// MARK: - UITableViewDataSource

extension ProductListViewController: UITableViewDataSource {}
