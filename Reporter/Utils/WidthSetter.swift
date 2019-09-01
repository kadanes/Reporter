
//
//  File.swift
//  Reporter
//
//  Created by Parth Tamane on 01/09/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

enum widthTypes: CGFloat {
    case large = 414
    case medium = 375
    case small = 320
}

func getReportCellWidth() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    var cellWidth: CGFloat
    switch screenWidth {
    //Xs Max, Xr, 6+, 6s+, 7+, 8+
    case widthTypes.large.rawValue:
        cellWidth = 180
    //X, Xs, 6, 6s, 7, 8
    case widthTypes.medium.rawValue:
        cellWidth = 150
    //5, 5s, 5c, SE, 4, 4s, 2G, 3G, 3GS
    case widthTypes.small.rawValue:
        cellWidth = 300
    default:
        cellWidth = 300
    }
    return cellWidth
}

func getReportCellMargin() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    var cellMargin: CGFloat
    switch screenWidth {
    //Xs Max, Xr, 6+, 6s+, 7+, 8+, X, Xs, 6, 6s, 7, 8
    case widthTypes.large.rawValue, widthTypes.medium.rawValue:
        cellMargin = (screenWidth - 2 * getReportCellWidth())/6
    //5, 5s, 5c, SE, 4, 4s, 2G, 3G, 3GS
    case widthTypes.small.rawValue:
        cellMargin = (screenWidth - getReportCellWidth())/4
    default:
        cellMargin = (screenWidth - getReportCellWidth())/4

    }
    return cellMargin
}
