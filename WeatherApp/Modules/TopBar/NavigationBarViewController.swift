//
//  NavigationBar.swift
//  WeatherApp
//
//  Created by MacBook Air on 13.12.24.
//

import UIKit

class NavigationBarViewController: UINavigationBar {
    
    private let label = UILabel()
    
    func configure(text: String) {
        label.text = text
        setupSubviews()
    }
}


private extension NavigationBarViewController {
    
    func setupSubviews() {
        setupView()
        setupLabel()
        setupConstraints()
    }
    
    func setupView() {
        backgroundColor = UIColor(named: "WeatherTodayBackground")
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLabel() {
        label.textColor = UIColor(named: "ColorForLabel")
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)])
    }
}
