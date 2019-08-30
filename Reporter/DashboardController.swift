 //
//  Dashboard.swift
//  Reporter
//
//  Created by Parth Tamane on 28/08/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit
 
 let error = "Error"
 var reports: Reports? = nil
 var tags: [String] = []
 var filterOptionsView: UICollectionView!
 let filterOptionCellId = "FilterOptionsCell"
 var selectedTag = ""
 
 struct Report: Decodable {
    let date: String
    let description: String
    let tag: String
    let thumbnail: String
    let title: String
 }
 
 struct Reports: Decodable {
    let reports: [Report]
 }
 
 class DashboardController: UIViewController {
    
    
    override func loadView() {
        super.loadView()
        filterOptionsView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        filterOptionsView.translatesAutoresizingMaskIntoConstraints = false
        filterOptionsView.backgroundColor = .white
        self.view.addSubview(filterOptionsView)
        

        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                filterOptionsView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: filterOptionsView.bottomAnchor, multiplier: 1.0), guide.leftAnchor.constraint(equalToSystemSpacingAfter: filterOptionsView.leftAnchor, multiplier: -1.0), guide.rightAnchor.constraint(equalToSystemSpacingAfter: filterOptionsView.rightAnchor, multiplier: 1.0), guide.heightAnchor.constraint(equalToConstant: 80)
                ])
            
        } else {
            //Untested Code. Need Devices to fix.
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                filterOptionsView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: filterOptionsView.bottomAnchor, constant: standardSpacing)
                ])
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reports = readData()
        filterOptionsView.delegate = self
        filterOptionsView.dataSource = self
        filterOptionsView.register(OptionsCell.self, forCellWithReuseIdentifier: OptionsCell.identifier)
        if let layout = filterOptionsView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        filterOptionsView.showsHorizontalScrollIndicator = false
    
        guard let reports = reports else { return }
        
        for report in reports.reports {
            if !tags.contains(report.tag) {
                tags.append(report.tag)
            }
        }
    }
    
    func readData() -> Reports {
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "json") else {
            return
                Reports(reports: [Report(date: Date().description, description: error, tag: error, thumbnail: error, title: error)])
            
        }
        let fileUrl = URL(fileURLWithPath: filePath)

        do {
            
            let data = try JSONDecoder().decode(Reports.self, from: Data(contentsOf: fileUrl))
            return data
          
        } catch let jsonErr {
            print("Error reading the data file.")
            print(jsonErr.localizedDescription)
        }
        
        return  
            Reports(reports: [Report(date: Date().description, description: error, tag: error, thumbnail: error, title: error)])
    }
 }
 
 extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
 }
 
 extension DashboardController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterOptionsView {
            return tags.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterOptionsView {
            if let optionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCell.identifier, for: indexPath) as? OptionsCell {
                optionsCell.configureCell(option: tags[indexPath.row], selected: selectedTag == tags[indexPath.row])
                return optionsCell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterOptionsView {
            
            if selectedTag == tags[indexPath.row] {
                selectedTag = ""
                collectionView.reloadItems(at: [indexPath])
            } else {
                if (selectedTag == "") {
                    selectedTag = tags[indexPath.row]
                    collectionView.reloadItems(at: [indexPath])
                } else {
                    let oldIndexPath = IndexPath(row: tags.firstIndex(of: selectedTag)!, section: 0)
                    selectedTag = tags[indexPath.row]
                    collectionView.reloadItems(at: [oldIndexPath,indexPath])
                }
            }
        }
    }
 }
 
 extension DashboardController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == filterOptionsView {
            let size = (tags[indexPath.row] as NSString).size(withAttributes: nil)
            return CGSize(width: size.width * 1.7, height: 45)
        }

        return CGSize(width: collectionView.bounds.width/2, height: 44)
       
    }
    
 }
