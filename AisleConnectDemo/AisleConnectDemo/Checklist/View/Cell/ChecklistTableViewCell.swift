//
//  ChecklistTableViewCell.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import UIKit

// MARK: - NibInstantiable

extension ChecklistTableViewCell: NibInstantiable {}

class ChecklistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    

    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clearUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func clearUI() {
        titleLabel.text = ""
        countLabel.text = ""
    }
    
    func set(bookList: BookList) {
        titleLabel.text = bookList.name
        if let count = bookList.products?.count {
            countLabel.text = "\(count) books >"
        } else {
            countLabel.text = "-"
        }
        
    }
    
    
}
