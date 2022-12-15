//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 14/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let usernamePublish = PublishSubject<String>()
    let passwordPublish = PublishSubject<String>()
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    func isValid() -> Observable<(isValid: Bool, errorMessage: [String])> {
        return Observable.combineLatest(usernamePublish.asObserver(), passwordPublish.asObserver()).map({username, password in
            
            var isValidInputs = true
            var arrErrorMsg = ["", ""]
            
            if username.isEmptyString {
                arrErrorMsg[0] = ValidationMessage.emptyEmail
                isValidInputs = false
            }
            if password.isEmptyString {
                arrErrorMsg[1] = ValidationMessage.emptyPassword
                isValidInputs = false
            }
            // || !Utilites.validate(validationString: password, validationType: .password)
            if !Utilites.validate(validationString: username, validationType: .email) {
                arrErrorMsg[0] = ValidationMessage.invalidEmail
                isValidInputs = false
            }
            return (isValidInputs, arrErrorMsg)
        })
    }
    
    func login(username: String, password: String) -> Observable<AppUser> {
        
        self.loading.onNext(true)
        return Observable.create { observer -> Disposable in
            
            let params = ["email": username, "password": password]
            
            let client = APIClient.shared
            _ = client.sendPost(apiRoute: APIRoute(endPoint: .login, method: .POST, parameters: params as [String: Any])).subscribe(
                onNext: { result in
                    observer.onNext(result)
                },
                onError: { error in
                    self.loading.onNext(false)
                    observer.onError(error)
                },
                onCompleted: {
                    self.loading.onNext(false)
                    observer.onCompleted()
                    print("Completed event.")
                })
            
            return Disposables.create()
        }
    }
}
