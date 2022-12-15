//
//  String+Extension.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 14/12/22.
//

import Foundation

extension String {
    
    var isEmptyString: Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self == "N/A"
    }
    
    func convertToDate(fromFormat: AppDateFormates) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat.rawValue
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}
