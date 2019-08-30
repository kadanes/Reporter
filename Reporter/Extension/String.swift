//
//  String.swift
//  Reporter
//
//  Created by Parth Tamane on 30/08/19.
//  Copyright © 2019 Parth Tamane. All rights reserved.
//

import Foundation

extension String {
    func titlecased() -> String {
        return self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}
