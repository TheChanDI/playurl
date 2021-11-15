//
//  PlayerCell.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 11/14/21.
//

import UIKit

class PlayerItemCell: UITableViewCell {
    
    static let identifier = "playerItemCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
