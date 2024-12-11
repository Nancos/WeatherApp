//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by MacBook Air on 15.12.24.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    static let reuseId = "WeatherCell"
    
    private let weatherCellView = UIView()
    private var weatherImageView = UIImageView()
    private let timeLabel = UILabel()
    private let cloudsLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, time: String, clouds: String, temperature: String) {  
        weatherImageView.image = image
        timeLabel.text = time
        cloudsLabel.text = clouds
        temperatureLabel.text = temperature
    }
    
    
}

private extension WeatherCell {
    
    func setupViews() {
        backgroundColor = .weatherWeekBackground
        selectionStyle = .none
        setupWeatherCellView()
        setupWeatherImageView()
        setupTimeLabel()
        setupCloudsLabel()
        setupTemperatureLabel()
        
        setupConstraints()
    }
    
    func setupWeatherCellView() {
        weatherCellView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(weatherCellView)
    }
    
    func setupWeatherImageView() {
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherCellView.addSubview(weatherImageView)
    }
    
    func setupTimeLabel() {
        timeLabel.textColor = UIColor(named: "ColorForLabel")
        timeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.numberOfLines = 0
        timeLabel.textAlignment = .center

        weatherCellView.addSubview(timeLabel)
    }
    
    func setupCloudsLabel() {
        cloudsLabel.textColor = UIColor(named: "ColorForLabel")
        cloudsLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        cloudsLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudsLabel.numberOfLines = 0
        cloudsLabel.textAlignment = .center
        
        weatherCellView.addSubview(cloudsLabel)
    }
    
    func setupTemperatureLabel() {
        temperatureLabel.textColor = UIColor(named: "WeatherColor")
        temperatureLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.numberOfLines = 0
        temperatureLabel.textAlignment = .center
        
        weatherCellView.addSubview(temperatureLabel)
    }
    
    
    func setupConstraints() {
        
        // UIView
        NSLayoutConstraint.activate([
            weatherCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weatherCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
        // image clouds
        NSLayoutConstraint.activate([
            weatherImageView.heightAnchor.constraint(equalToConstant: 60),
            weatherImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherImageView.topAnchor.constraint(equalTo: weatherCellView.topAnchor),
            weatherImageView.bottomAnchor.constraint(equalTo: weatherCellView.bottomAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: weatherCellView.leadingAnchor)
        ])
        // time label
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: weatherCellView.topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: weatherImageView.rightAnchor,
                                               constant: 15)
        ])
        // clouds label
        NSLayoutConstraint.activate([
            cloudsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,
                                           constant: 10),
            cloudsLabel.leftAnchor.constraint(equalTo: weatherImageView.rightAnchor,
                                               constant: 15)
        ])
        // temp label
        NSLayoutConstraint.activate([
            temperatureLabel.centerYAnchor.constraint(equalTo: weatherCellView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherCellView.trailingAnchor)
            ])
    }
    
}
