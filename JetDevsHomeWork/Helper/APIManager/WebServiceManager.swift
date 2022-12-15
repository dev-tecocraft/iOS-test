//
//  WebServiceManager.swift
//
//  Created by Sanam on 23/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI

public enum RequestType: String {
    case GET, POST, PUT, DELETE
}

public enum ApiEndPoints: String {
    case login = "login"
    case none = ""
}

public class RequestObservable {
    
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config: URLSessionConfiguration) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    private func isConnected() -> Bool {
        var connected: Bool = false
        do {
            let reachability = try Reachability()
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                print("Reachable via WiFi")
                connected = true
            }
            
            if reachability.connection == .unavailable {
                print("Not reachable")
                connected = false
            }
        } catch {
            return false
        }
        
        return connected
    }
    
    public func callAPI<ItemModel: Decodable>(request: URLRequest) -> Observable<ItemModel> {
        return Observable.create { observer in
            
            if !self.isConnected() {
                let error = NSError(domain: "Please check your internet connection", code: 400, userInfo: nil)
                observer.onError(error as Error)
            }
            
            let task = self.urlSession.dataTask(with: request) {(data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let mydata = data ?? Data()
                        if (200...399).contains(statusCode) == true {
                            let objs = try self.jsonDecoder.decode(ItemModel.self, from: mydata)
                            
                            if let headers = httpResponse.allHeaderFields as NSDictionary? as? [String: Any]?, let authToken = headers?["X-Acc"] as? String {
                                UserDefaults.standard.set(authToken, forKey: AuthKeys.kAuthToken.string)
                            }
                            observer.onNext(objs)
                        } else {
                            if let error = error {
                                observer.onError(error)
                            } else {
                                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                                observer.onError(error as Error)
                            }
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

fileprivate extension Encodable {
    
    var dictionaryValue: [String: Any?]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                  return nil
              }
        return dictionary
    }
}

class APIClient {

    static var shared = APIClient()
    lazy var requestObservable = RequestObservable(config: .default)
    
    func sendPost(apiRoute: APIRoute) -> Observable<AppUser> {
        let strURL = baseURL + apiRoute.endPoint.rawValue
        var request = URLRequest(url: URL(string: strURL)!)
        let param = apiRoute.parameters
        request.httpMethod = apiRoute.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let payloadData = try? JSONSerialization.data(withJSONObject: param, options: [])
        request.httpBody = payloadData
        return requestObservable.callAPI(request: request)
    }
}

public struct APIRoute {

    let endPoint: ApiEndPoints
    var method: RequestType
    var parameters: [String: Any]
}
