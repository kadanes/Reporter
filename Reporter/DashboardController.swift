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
 var selectedTag = ""
 var sortedReports: [String: [Report]] = [:]
 var fetchingThumbnails: [String] = []
 var loadedThumbnails: [String: UIImage] = [:]
 
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
        
        let reportsViewLayout = AlignedCollectionViewFlowLayout()
        reportsViewLayout.verticalAlignment = .top
        reportsViewLayout.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
        reportsView = UICollectionView(frame: .zero, collectionViewLayout: reportsViewLayout)
        reportsView.translatesAutoresizingMaskIntoConstraints = false
        reportsView.backgroundColor = .white
        reportsView.layer.masksToBounds = true
        self.view.addSubview(reportsView)

        filterOptionsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: getReportCellMargin()).isActive = true
        filterOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -1.0 * getReportCellMargin()).isActive = true
        filterOptionsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        
        reportsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        reportsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: getReportCellMargin()).isActive = true
        reportsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1.0 *  getReportCellMargin()).isActive = true
        reportsView.topAnchor.constraint(equalTo: filterOptionsView.bottomAnchor, constant: 5).isActive = true
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
                sortedReports[report.tag]!.append(report)
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
    
    func fetchImage(from report: Report) {
        if let _ = fetchingThumbnails.firstIndex(of: report.title) { return }
        fetchingThumbnails.append(report.title)
        guard let url = URL(string: report.thumbnail) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else {
                fetchingThumbnails.remove(at: fetchingThumbnails.firstIndex(of: report.title)!)
                return
            }
            DispatchQueue.main.async() {
                loadedThumbnails[report.title] = UIImage(data: data)
                reportsView.reloadData()
            }
        }).resume()
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
            }
            return reports?.reports.count ?? 0
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
                if let currentReport = selectedTag == "" ? reports?.reports[indexPath.row] : sortedReports[selectedTag]?[indexPath.row] {
                    if let thumbnail = loadedThumbnails[currentReport.title] {
                        reportCell.configureCell(thumbnail: thumbnail, date: currentReport.date, title: currentReport.title, description: currentReport.description)
                        return reportCell
                    } else {
                        fetchImage(from: currentReport)
                        reportCell.configureCell(thumbnail: nil, date: currentReport.date, title: currentReport.title, description: currentReport.description)
                        return reportCell
                    }
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
            return CGSize(width: size.width * 1.6, height: 45)
        }
        return CGSize(width: 1.0, height: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == reportsView {
             return UIEdgeInsets(top: 0, left: getReportCellMargin(), bottom: 10, right: getReportCellMargin())
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
 }
