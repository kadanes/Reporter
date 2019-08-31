 //
//  Dashboard.swift
//  Reporter
//
//  Created by Parth Tamane on 28/08/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit
 
 let errorLog = "Error"
 let undefinedLog = "Undefined"
 var reports: Reports? = nil
 var tags: [String] = []
 var filterOptionsView: UICollectionView!
 var reportsView: UICollectionView!
 let filterOptionCellId = "FilterOptionsCell"
 var selectedTag = ""
 var sortedReports: [String: [Report]] = [:]
 
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
        
        let reportsViewLayout = TopAlignedCollectionViewFlowLayout()
        reportsViewLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
        reportsView = UICollectionView(frame: .zero, collectionViewLayout: reportsViewLayout)
        reportsView.translatesAutoresizingMaskIntoConstraints = false
        reportsView.backgroundColor = .blue
        self.view.addSubview(reportsView)

        filterOptionsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        filterOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive = true
        filterOptionsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        
        reportsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        reportsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        reportsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        reportsView.topAnchor.constraint(equalTo: filterOptionsView.bottomAnchor, constant: 1).isActive = true
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
        
        reportsView.delegate = self
        reportsView.dataSource = self
        reportsView.register(ReportCell.self, forCellWithReuseIdentifier: ReportCell.identifier)
        
        guard let reports = reports else { return }
        
        for report in reports.reports {
            if !tags.contains(report.tag) {
                tags.append(report.tag)
            }
            
            if let _ = sortedReports[report.tag] {
                sortedReports[report.tag]?.append(report)
            } else {
                sortedReports[report.tag] = [report]
            }
        }
        
    }
    
    func readData() -> Reports {
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "json") else {
            return
                Reports(reports: [Report(date: Date().description, description: errorLog, tag: errorLog, thumbnail: errorLog, title: errorLog)])
            
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
            Reports(reports: [Report(date: Date().description, description: errorLog, tag: errorLog, thumbnail: errorLog, title: errorLog)])
    }
 }
 
 extension DashboardController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterOptionsView {
            return tags.count
        }
        if collectionView == reportsView {
           
            if selectedTag != "" {
                return sortedReports[selectedTag]?.count ?? 0
//                return 1
            }
            
            return reports?.reports.count ?? 0
//            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterOptionsView {
            if let optionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCell.identifier, for: indexPath) as? OptionsCell {
                optionsCell.configureCell(option: tags[indexPath.row], selected: selectedTag == tags[indexPath.row])
                return optionsCell
            }
        } else if collectionView == reportsView {
            
            if let reportCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportCell.identifier, for: indexPath) as? ReportCell {
                
                if selectedTag != "" {
                    let currentReport = sortedReports[selectedTag]?[indexPath.row]
                    reportCell.configureCell(thumbnail: nil, date: currentReport?.date ?? undefinedLog, title: currentReport?.title ??  undefinedLog, description: currentReport?.description ?? undefinedLog)
                    return reportCell
                } else {
                    let currentReport = reports?.reports[indexPath.row]
                    reportCell.configureCell(thumbnail: nil, date: currentReport?.date ?? undefinedLog, title: currentReport?.title ?? undefinedLog, description: currentReport?.description ?? undefinedLog)
                    return reportCell
                }
                
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
            reportsView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == reportsView {
             return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
 }

 //2
 class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attrs = super.layoutAttributesForElements(in: rect) {
            var baseline: CGFloat = -2
            var sameLineElements = [UICollectionViewLayoutAttributes]()
            for element in attrs {
                if element.representedElementCategory == .cell {
                    let frame = element.frame
                    let centerY = frame.midY
                    if abs(centerY - baseline) > 1 {
                        baseline = centerY
                        alignToTopForSameLineElements(sameLineElements: sameLineElements)
                        sameLineElements.removeAll()
                    }
                    sameLineElements.append(element)
                }
            }
            alignToTopForSameLineElements(sameLineElements: sameLineElements) // align one more time for the last line
            return attrs
        }
        return nil
    }
    
    private func alignToTopForSameLineElements(sameLineElements: [UICollectionViewLayoutAttributes]) {
        if sameLineElements.count < 1 { return }
        let sorted = sameLineElements.sorted { (obj1: UICollectionViewLayoutAttributes, obj2: UICollectionViewLayoutAttributes) -> Bool in
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            let delta = height1 - height2
            return delta <= 0
        }
        if let tallest = sorted.last {
            for obj in sameLineElements {
                obj.frame = obj.frame.offsetBy(dx: 0, dy: tallest.frame.origin.y - obj.frame.origin.y)
            }
        }
    }
 }
