//
//  NavigationBar.swift
//  WeatherApp
//
//  Created by MacBook Air on 13.12.24.
//

import UIKit

class StackViewTopBar: UIStackView {
    
    private let label = UILabel()
    
    func confgure(text: String) {
        label.text = text
        setupSettings()
    }
    
}


private extension StackViewTopBar {
    
    func setupSettings() {
        backgroundColor = UIColor(named: "WeatherTodayBackground")
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        setupLabel()
    }
    
    func setupLabel() {
        label.textColor = UIColor(named: "ColorForLabel")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        self.addArrangedSubview(label)
    }
    
}
