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
 let filterOptionsView = UICollectionView()
 let filterOptionCellId = "FilterOptionsCell"

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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reports = readData()
        filterOptionsView.delegate = self
        filterOptionsView.dataSource = self
        
        
        guard let reports = reports else { return }
        
        for report in reports.reports {
            if (!tags.contains(report.tag)) {
                tags.append(report.tag)
            }
        }
        
        print(tags)
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
        
        
        
        return UICollectionViewCell()
    }
 }
