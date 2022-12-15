//
//  ReusableProfileInputView.swift
//
//  Created by Sanam on 28/06/22.
//

import UIKit

protocol ReusableInputViewDelegate: AnyObject {
    
    /// This method is called when specific view is tapped which is confirm this delegate.
    func textfieldClicked(_ sender: UIView)
}

class ReusableProfileInputView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var vwMainBorder: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwTitle: UIView!
    @IBOutlet weak var lblValidation: UILabel!
    
    // MARK: - Variables
    var contentView: UIView?
    let nibName = NibIdentifierName.reusableInputView
    weak var reusableInputViewDelegate: ReusableInputViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: - IBInspectable
    @IBInspectable var placeholderString: String = "" {
        didSet {
            self.lblTitle.text = placeholderString
                self.txtInput.attributedPlaceholder = NSAttributedString(
                    string: placeholderString,  /// Concate string for display placeholder.
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.appFontBlackClr, .font: UIFont.latoRegularFont(size: 14)]
                )
        }
    }
  
    @IBInspectable var isSecureEntry: Bool = false {
        didSet {
            self.txtInput.isSecureTextEntry = isSecureEntry
        }
    }
  
    @IBInspectable var isSelectView: Bool = false {
        didSet {
            /// If input textfield is non empty then make view selected.
            if isSelectView || !(self.txtInput.text?.isEmptyString ?? true) {
                self.configSelectedView()
                self.isSelectView = true
            } else {
                self.configUnSelectedView()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func commonInit() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        initialConfig()
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /**
        This method is used for initial config for controlls.
     */
    private func initialConfig() {
        self.vwMainBorder.borderWidth(1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTapped))
        self.vwMainBorder.addGestureRecognizer(tapGesture)
        self.vwMainBorder.cornerRadius(7)
        
        self.txtInput.tintColor = .appFontBlackClr
        self.txtInput.font = UIFont.latoRegularFont(size: 14.0)
        self.txtInput.textColor = .appFontBlackClr
        
        self.lblTitle.text = ""
        self.lblTitle.font = UIFont.latoRegularFont(size: 12.0)
        self.lblTitle.textColor = .appFontBlackClr
        
        self.lblTitle.font = UIFont.latoRegularFont(size: 14.0)
        self.lblTitle.textColor = .appThemeClr

        self.configUnSelectedView()
    }
    
    /**
        This method is used for config unselected controlls.
     */
    private func configUnSelectedView() {
        self.vwMainBorder.borderColor(UIColor.appBorderClr)
        self.txtInput.placeholder = placeholderString
        self.vwTitle.isHidden = true
       
        if (self.txtInput.text?.isEmptyString ?? true) == true { /// For remove white space and display placeholder.
            self.txtInput.text = ""
        }
        self.txtInput.resignFirstResponder()
    }
    /**This method is used for config selected controlls.*/
    private func configSelectedView() {
        self.vwMainBorder.borderColor(UIColor.appThemeClr)
        self.txtInput.placeholder = ""
        self.vwTitle.isHidden = false
    }
}

// MARK: - UIView TapGesture Method
extension ReusableProfileInputView {
    
    @objc func handleViewTapped(sender: UIGestureRecognizer) {
        reusableInputViewDelegate?.textfieldClicked(self)
    }
}
