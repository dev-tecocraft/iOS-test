//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Sanam on 13/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var vwEmailInput: ReusableProfileInputView!
    @IBOutlet weak var vwPasswordInput: ReusableProfileInputView!
    
    @IBOutlet weak var btnLogin: ThemeButton!
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    var user: AppUser = AppUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initConfig()
        bindUIs()
        handleValidation()
    }
    
    // MARK: - IBActions
    @IBAction func btnLogin_Clicked(_ sender: UIButton) {

        loginViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        loginViewModel.login(username: vwEmailInput.txtInput.text ?? "", password: vwPasswordInput.txtInput.text ?? "")
            .subscribe(
                onNext: { [weak self] user in
                    // The button was tapped while the last value from allValid was true.
                    
                    if user.result == 1, let user = user.loginData?.user {
                        UserDefaults.saveUserDataInDefault(userData: user)
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.displayAlert(title: "Error", message: user.errorMessage ?? "")
                        }
                    }
                },
                onError: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.displayAlert(title: "Error", message: error.localizedDescription)
                    }
                }).disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    func initConfig() {
        
        [vwEmailInput, vwPasswordInput].forEach {
            $0?.txtInput.delegate = self
            $0?.reusableInputViewDelegate = self
        }
        
        vwEmailInput.txtInput.textContentType = .username
        vwPasswordInput.txtInput.textContentType = .password
        
        vwEmailInput.tag = 1
        vwPasswordInput.tag = 2
        
        vwEmailInput.placeholderString = PlaceholderText.emailAddress
        vwPasswordInput.placeholderString = PlaceholderText.password
        
        vwEmailInput.lblTitle.text = PlaceholderText.emailAddress
        vwPasswordInput.lblTitle.text = PlaceholderText.password
        
        vwEmailInput.txtInput.keyboardType = .emailAddress
        vwPasswordInput.txtInput.keyboardType = .default
        
        vwEmailInput.txtInput.returnKeyType = .next
        vwPasswordInput.txtInput.returnKeyType = .done
        
        vwEmailInput.isSecureEntry = false
        vwPasswordInput.isSecureEntry = true
        
        btnLogin.backgroundColor = .appBorderClr
        btnLogin.setTitle(LoginStr.btnLogin, for: .normal)
        btnLogin.isEnabled = false
    }
    
    func bindUIs() {
        vwEmailInput.txtInput.rx.text.map({ $0 ?? "" }).bind(to: loginViewModel.usernamePublish).disposed(by: disposeBag)
        vwPasswordInput.txtInput.rx.text.map({ $0 ?? "" }).bind(to: loginViewModel.passwordPublish).disposed(by: disposeBag)
    }
    
    func handleValidation() {
        loginViewModel.isValid()
            .subscribe(onNext: { [weak self] result in
                // The button was tapped while the last value from allValid was true.
                
                // Make button Enable disable
                self?.btnLogin.isEnabled = result.isValid
                
                // Change background color of button
                if result.isValid {
                    self?.btnLogin.backgroundColor = UIColor.appThemeClr
                } else {
                    self?.btnLogin.backgroundColor = UIColor.appBorderClr
                }
                
                // Display Error message
                self?.vwEmailInput.lblValidation.text = result.errorMessage[0]
                self?.vwPasswordInput.lblValidation.text = result.errorMessage[1]
                
            }).disposed(by: disposeBag)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextfieldDelgate Methods
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Make textfield selected/unselected here.
        if textField == self.vwEmailInput.txtInput {
            self.vwEmailInput.isSelectView = !(self.vwEmailInput.isSelectView)
            self.vwPasswordInput.isSelectView = false // If email field get selected then password will make unselected.
        } else if textField == self.vwPasswordInput.txtInput {
            self.vwPasswordInput.isSelectView = !(self.vwPasswordInput.isSelectView)
            self.vwEmailInput.isSelectView = false // If password field get selected then email will make unselected.
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // For make all empty textfields unselected.
        [self.vwEmailInput, self.vwPasswordInput].forEach {
            if ($0?.txtInput.text?.isEmpty ?? true) == true {
                $0?.isSelectView = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vwEmailInput.txtInput {
            self.vwPasswordInput.txtInput.becomeFirstResponder()
            self.vwEmailInput.isSelectView = false
        } else {
            self.vwPasswordInput.txtInput.resignFirstResponder()
            self.vwPasswordInput.isSelectView = false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - ReusableInput Fields Methods
extension LoginViewController: ReusableInputViewDelegate {
    
    func textfieldClicked(_ sender: UIView) {
        // Make textfield selected/unselected here.
        if sender.tag == self.vwEmailInput.tag {
            self.vwEmailInput.isSelectView = !(self.vwEmailInput.isSelectView)
            self.vwEmailInput.txtInput.becomeFirstResponder()
            self.vwPasswordInput.isSelectView = false
        } else if sender.tag == self.vwPasswordInput.tag {
            self.vwPasswordInput.isSelectView = !(self.vwPasswordInput.isSelectView)
            self.vwPasswordInput.txtInput.becomeFirstResponder()
            self.vwEmailInput.isSelectView = false
        }
    }
}
