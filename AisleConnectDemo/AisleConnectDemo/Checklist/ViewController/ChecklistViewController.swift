//
//  ChecklistViewController.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/11.
//

import UIKit


// MARK: - StoryboardInstantiable

extension ChecklistViewController: StoryboardInstantiable {}


/// 書本列表頁
class ChecklistViewController: UIViewController {

    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    private var infos: [BookList] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        register()
        setupTableView()
        loadData()
    }
    
    // MARK: - Method
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    private func register() {
        let nib = UINib(nibName: ChecklistTableViewCell.nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ChecklistTableViewCell.nibName)
    }
    
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    

    private func loadData() {
        ChecklistCache.shared.getData { (info) in
            DispatchQueue.main.async {
                self.infos = info
                self.tableView.reloadData()
            }
            
        } errorHandler: { (_) in
            
        }
    }
    
    
}

// MARK: - UITableViewDelegate

extension ChecklistViewController:  UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = infos[indexPath.row]
        if let productList = info.products {
            let vc = ProductListViewController.instantiate()
            vc.set(productList: productList)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


// MARK: - UITableViewDataSource

extension ChecklistViewController:  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.isEmpty ? 0 : infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChecklistTableViewCell.nibName, for: indexPath) as! ChecklistTableViewCell
        
        let info = infos[indexPath.row]
        
        cell.set(bookList: info)
        
        return cell
    }
    
    
}
