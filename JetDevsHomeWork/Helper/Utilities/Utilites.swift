//
//  GlobalFunctions.swift
//
//  Created by Sanam on 29/06/22.
//
import Foundation

struct Utilites {
    
    /// This method is used for validate input field string.
    /// - Parameters:
    ///   - validationString: the input string which need to be verify.
    ///   - validationType: the validation type which we already define with custom type 'ValidationType' enum.
    /// - Returns: return 'true' if input validationString full fill all the validation.
    static func validate(validationString: String, validationType: ValidationType) -> Bool {
        var validationResult = Bool()
        var REGEX = String()
        
        // Minimum 3 character or number:
        let PASSWORDREGEX = "^[a-zA-Z1-9]{3,}"
        
        let EMAILREGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        switch validationType {
        case .email:
            REGEX = EMAILREGEX
        case .password:
            REGEX = PASSWORDREGEX
            
        }
        let resultPredicate = NSPredicate(format: "SELF MATCHES %@", REGEX)
        let result = resultPredicate.evaluate(with: validationString)
        validationResult = result
        
        return validationResult
    }
}

enum ValidationType {
    case email
    case password
}
