//
//  Userdefault+Extension.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 14/12/22.
//

import Foundation

extension UserDefaults {
    
    class func setData<T: Codable>(data: T, forKey key: String) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(jsonData, forKey: key)
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error)
        }
    }
    
    class func getData<T: Codable>(objectType: T.Type, forKey key: String) -> T? {
        guard let result = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(objectType, from: result)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    class func saveUserDataInDefault(userData: User) {
        self.setData(data: userData, forKey: AuthKeys.kLoginUser.string)
    }
    
    class func getUserDataFromDefault() -> User? {
        self.getData(objectType: User.self, forKey: AuthKeys.kLoginUser.string)
    }
}
