//
//  WeatherTodayUIImageView.swift
//  WeatherApp
//
//  Created by MacBook Air on 13.12.24.
//

import UIKit

class HorizontalStackView: UIStackView {
    
    private let cloudsImageView = UIImageView()
    private let labelCityCountry = UILabel()
    private let labelTemperatureClouds = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, country: String, temperature: String) {
        cloudsImageView.image = image
        labelCityCountry.text = country
        labelTemperatureClouds.text = temperature
    }
    
    
}


private extension HorizontalStackView {
    
    func setupStack() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .equalCentering
        alignment = .center

        setupLabelCityCountry()
        setupTemperatureLabel()
        
        addArrangedSubview(cloudsImageView)
        addArrangedSubview(labelCityCountry)
        addArrangedSubview(labelTemperatureClouds)
    }
    
    
    func setupLabelCityCountry() {
        labelCityCountry.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelCityCountry.textColor = UIColor(named: "ColorForLabel")
        labelCityCountry.numberOfLines = 0
        labelCityCountry.textAlignment = .center
    }
    
    func setupTemperatureLabel() {
        labelTemperatureClouds.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        labelTemperatureClouds.textColor = UIColor(named: "WeatherColor")
        labelTemperatureClouds.numberOfLines = 0
        labelTemperatureClouds.textAlignment = .center
    }
    
}
