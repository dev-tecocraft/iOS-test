//
//  Date+Extension.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 15/12/22.
//

import Foundation
extension Date {
    
    func getDays() -> String {
        let diffs = Calendar.current.dateComponents([.day], from: self, to: Date())
        return String(diffs.day ?? 0)
    }
}
