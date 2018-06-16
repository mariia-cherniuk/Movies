//
//  Date.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import Foundation

extension Date {
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func previousMonthString() -> String {
        let previousMonth = self.getPreviousMonth()
        
        return previousMonth?.stringDate() ?? ""
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}
