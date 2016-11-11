//
//  TableViewCell.swift
//  TableViewCheckMarkSample
//
//  Created by RS on 2016/11/11.
//  Copyright © 2016年 RS. All rights reserved.
//

import UIKit


// MARK: - TableViewCell

class TableViewCell: UITableViewCell {
    
    
    // MARK: Internal
    
    internal var item: ViewController.Music! {
        
        didSet {
            
            iconImageView.image = UIImage(named: item.imageName())
            nameLabel.text = item.createrName()
        }
    }

    
    // MARK: UITableViewCell
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    // MARK: Private
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
}
