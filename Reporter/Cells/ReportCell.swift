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
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var reportTag: UILabel!
    var thumbnail: UIImageView!
    var activityInd = UIActivityIndicatorView(style: .gray)
    var imageContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let width = UIScreen.main.bounds.width
        var cellWidth: CGFloat = 180
        
        switch width {
        //Xs Max, Xr, 6+, 6s+, 7+, 8+
        case 414:
           cellWidth = 180
        
        //X, Xs, 6, 6s, 7, 8
        case 375:
            cellWidth = 340
            
        //5, 5s, 5c, SE, 4, 4s, 2G, 3G, 3GS
        case 320:
            cellWidth = 300
            
        default:
            cellWidth = 180
        }
        
        contentView.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
    
        imageContainer = UIView(frame: .zero)
        dateLabel = UILabel(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        descriptionLabel = UILabel(frame: .zero)
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(activityInd)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        activityInd.hidesWhenStopped = true

        imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0 ).isActive = true
        imageContainer.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: cellWidth).isActive = true
        imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageContainer.layer.borderWidth = 1
        
        activityInd.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor, constant: 0).isActive = true
        activityInd.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 0).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 5).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        dateLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 11)
        descriptionLabel.textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
            
        contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func configureCell(thumbnail: UIImage?, date: String, title: String, description: String ) {
        titleLabel.text = title.capitalized
        let dateObj = Formatter.iso8601.date(from: date)
        let dateString = Formatter.dmmyyyy.string(from: dateObj!)
        dateLabel.text = dateString
        descriptionLabel.text = description
        
        self.contentView.backgroundColor = .orange
        
        if let image = thumbnail {
            
        } else {
            activityInd.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

