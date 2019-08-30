//
//  OptionsCell.swift
//  Reporter
//
//  Created by Parth Tamane on 29/08/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: UICollectionViewCell {
    static let identifier: String = "OptionsCell"
    var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            ])
    }
    
    func configureCell(option: String, selected: Bool) {
        label.text = option.titlecased()
        label.textColor = selected ?
            UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0):
            UIColor(red:0.64, green:0.64, blue:0.64, alpha:1.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

