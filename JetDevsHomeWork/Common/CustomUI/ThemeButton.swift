//
//  ThemeButton.swift

import UIKit
import Foundation

class ThemeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        
        self.setTitleColor(.appFontWhiteClr, for: .normal)
        self.titleLabel?.font = .latoRegularFont(size: 18)
        self.backgroundColor = .appThemeClr
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
    }
}
