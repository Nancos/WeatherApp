//
//  CoupleCustomView.swift
//  WeatherApp
//
//  Created by MacBook Air on 13.12.24.
//
import UIKit
import SnapKit

class CoupleCustomView: UIView {
    
    private let cloudsCustomView = CustomView()
    private let pressureCustomView = CustomView()
    private let humidityCustomView = CustomView()
    private let windSpeedCustomView = CustomView()
    private let windDegreeCustomView = CustomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(clouds: String, cloudsImageString: String,
                   pressure: String, pressureImageString: String,
                   humidity: String, humidityImageString: String,
                   windSpeed: String, windSpeedImageString: String,
                   windDegree: String, windDegreeImageString: String) {
        cloudsCustomView.configure(text: clouds, imageString: cloudsImageString)
        pressureCustomView.configure(text: pressure, imageString: pressureImageString)
        humidityCustomView.configure(text: humidity, imageString: humidityImageString)
        windSpeedCustomView.configure(text: windSpeed, imageString: windSpeedImageString)
        windDegreeCustomView.configure(text: windDegree, imageString: windDegreeImageString)
    }
}

private extension CoupleCustomView {
    func setupSubviews() {
        setupView()
        setupCloudsCustomView()
        setupPressureCustomView()
        setupHumidityCustomView()
        setupWindSpeedCustomView()
        setupWindDegreeCustomView()

        setupConstraints()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCloudsCustomView() {
        addSubview(cloudsCustomView)
    }
    
    func setupPressureCustomView() {
        addSubview(pressureCustomView)
    }
    
    func setupHumidityCustomView() {
        addSubview(humidityCustomView)
    }
    
    func setupWindSpeedCustomView() {
        addSubview(windSpeedCustomView)
    }
    
    func setupWindDegreeCustomView() {
        addSubview(windDegreeCustomView)
    }

    func setupConstraints() {
        cloudsCustomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(windSpeedCustomView).offset(-16)
        }
        pressureCustomView.snp.makeConstraints { make in
            make.leading.equalTo(cloudsCustomView.snp.trailing).offset(64)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(windSpeedCustomView) .offset(-16)
        }
        humidityCustomView.snp.makeConstraints { make in
            make.leading.equalTo(pressureCustomView.snp.trailing).offset(64)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(windSpeedCustomView).offset(-16)
        }
        windSpeedCustomView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.leading.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-16)
        }
        windDegreeCustomView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
