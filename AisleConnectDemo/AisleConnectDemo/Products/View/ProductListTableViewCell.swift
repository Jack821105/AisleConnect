//
//  ProductListTableViewCell.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/18.
//

import UIKit
import SDWebImage

// MARK: - NibInstantiable

extension ProductListTableViewCell: NibInstantiable {}


class ProductListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    
    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(info: Product) {
        bookImageView.sd_setImage(with: URL(string: info.imageUrl ?? ""), completed: nil)
        bookTitleLabel.text = info.name
        authorsLabel.text = info.authors?.first!
    }
    
    
}
