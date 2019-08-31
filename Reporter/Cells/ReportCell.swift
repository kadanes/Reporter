//
//  ReportCell.swift
//  Reporter
//
//  Created by Parth Tamane on 30/08/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

class ReportCell: UICollectionViewCell {
    static let identifier: String = "ReportCell"
    var titleLabel: UILabel!
    var date: Date!
    var reportDescription: UILabel!
    var reportTag: UILabel!
    var thumbnail: UIImageView!
    var activityInd = UIActivityIndicatorView(style: .gray)
    var imageContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageContainer = UIView(frame: .zero)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(activityInd)
        imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1 ).isActive = true
        imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1).isActive = true
        imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1).isActive = true
        imageContainer.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: contentView.bounds.width - 20).isActive = true
//        self.activityInd.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
//        self.activityInd.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        imageContainer.layer.borderWidth = 1
        
     
        self.imageContainer.centerXAnchor.constraint(equalTo: activityInd.centerXAnchor).isActive = true
        self.imageContainer.centerYAnchor.constraint(equalTo: activityInd.centerYAnchor).isActive = true
        activityInd.hidesWhenStopped = true
        activityInd.startAnimating()
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        titleLabel.font = titleLabel.font.withSize(14)

      
    }
    
    func configureCell(title: String ) {
        titleLabel.text = title.capitalized
        self.contentView.backgroundColor = .orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

