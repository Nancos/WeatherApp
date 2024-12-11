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
    
    func configure(textArray: [String], imageStringArray: [String]) {
        translatesAutoresizingMaskIntoConstraints = false
        cloudsCustomView.configure(text: textArray[0] + "%", imageString: imageStringArray[0])
        pressureCustomView.configure(text: textArray[1] + "hPa", imageString: imageStringArray[1])
        humidityCustomView.configure(text: textArray[2] + "%", imageString: imageStringArray[2])
        windSpeedCustomView.configure(text: textArray[3] + "m/s", imageString: imageStringArray[3])
        windDegreeCustomView.configure(text: textArray[4], imageString: imageStringArray[4])
    }
    
}

private extension CoupleCustomView {
    
    func setupSubviews() {
        setupCloudsCustomView()
        setupPressureCustomView()
        setupHumidityCustomView()
        setupWindSpeedCustomView()
        setupWindDegreeCustomView()

        setupConstraints()
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
