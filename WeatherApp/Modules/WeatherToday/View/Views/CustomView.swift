//
//  CustomView.swift
//  WeatherApp
//
//  Created by MacBook Air on 13.12.24.
//

import UIKit

class CustomView: UIView {
    
    private let label = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, imageString: String) {
        label.text = text
        imageView.image = UIImage(named: imageString)
    }
}

// MARK: - SETUP UIView -

private extension CustomView {
    func setupSubviews() {
        setupLabel()
        setupImageView()
        setupConstraints()
    }
    
    func setupLabel() {
        label.textColor = UIColor(named: "ColorForLabel")
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        self.addSubview(label)
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0)
        ])
    }
}
