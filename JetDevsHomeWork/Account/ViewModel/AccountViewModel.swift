//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 15/12/22.
//

import Foundation

class AccountViewModel {
    
    func getDays(created: String) -> String {
        
        let createdDate = created.convertToDate(fromFormat: .yyyyMMddHHmmssTZ)
        let days = (createdDate?.getDays() ?? "0")
        return "Created " + days + " days ago"
    }
}
