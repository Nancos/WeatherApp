//
//  WeatherTodayPresenter.swift
//  WeatherApp
//
//  Created by MacBook Air on 16.12.24.
//

import UIKit

protocol WeatherTodayDelegate {
    func configureView(with weatherTodayModelData: WeatherTodayModelData, sharedString: String)
    func showAlert(title: String, message: String,
                   firstActionTitle: String, firstActionHandler: @escaping (() -> Void),
                   secondActionTitle: String?, secondActionHandler: @escaping (() -> Void))
}

class WeatherTodayPresenter {
    private let locationManager = LocationManager.shared
    private let apiManager = APIManager.shared
    private let model = WeatherTodayModel()
    var delegate: WeatherTodayDelegate?
}

// MARK: - Location Manager -

extension WeatherTodayPresenter {
    
    func getLocation() {
        locationManager.getUserLocation(
            successCompletion: { [weak self] location in
                self?.getWeatherTodayModelData(latitude: Float(location.coordinate.latitude),
                                              longitude: Float(location.coordinate.longitude))
            },
            failureCompletion: { [weak self] location in
                self?.delegate?.showAlert(
                    title: "Location Access Denied",
                    message: "Please allow location access to use this app",
                    firstActionTitle: "Settings",
                    firstActionHandler: {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                    },
                    secondActionTitle: "Close",
                    secondActionHandler: { [weak self] in
                        self?.getWeatherTodayModelData(latitude: Float(location.coordinate.latitude),
                                                       longitude: Float(location.coordinate.longitude))
                        self?.delegate?.showAlert(title: "Can't open settings",
                                                  message: "Нам не удалось получить данные вашей геопозиции",
                                                  firstActionTitle: "ok", firstActionHandler: {},
                                                  secondActionTitle: nil, secondActionHandler: {})
                    })
            })
    }
    
    private func getWeatherTodayModelData(latitude: Float, longitude: Float) {
        model.getWeatherData(latitude: latitude,
                             longitude: longitude) { [weak self] weatherTodayModelData, error in
            
            guard let `self`, let delegate else { return }
            
            guard error == nil else {
                delegate.configureView(with: self.emptyData(),
                                       sharedString: self.createSharedString(with: self.emptyData(),
                                                                             error: error))
                
                return delegate.showAlert(title: "Error",
                                          message: String(describing: error ?? .none),
                                          firstActionTitle: "Ok",
                                          firstActionHandler: {},
                                          secondActionTitle: nil, secondActionHandler: {})
            }
            
            guard let weatherTodayModelData else {
                delegate.configureView(with: self.emptyData(),
                                       sharedString: self.createSharedString(with: self.emptyData()))
                
                return delegate.showAlert(title: "Error",
                                          message: "promlem's with data...",
                                          firstActionTitle: "Ok",
                                          firstActionHandler: {},
                                          secondActionTitle: nil, secondActionHandler: {})
            }
            
            delegate.configureView(with: weatherTodayModelData,
                                   sharedString: self.createSharedString(with: weatherTodayModelData))
        }
    }
    
    func createSharedString(with weatherTodayModelData: WeatherTodayModelData, error: Error? = nil) -> String {
        if error == nil {
            return "Сейчас в \(weatherTodayModelData.city), \(weatherTodayModelData.country) \(weatherTodayModelData.temp) | \(weatherTodayModelData.descriptionClouds), облачно \(weatherTodayModelData.clouds)%, давление \(weatherTodayModelData.pressure) мм Hg, влажность \(weatherTodayModelData.humidity)%, скорость ветра \(weatherTodayModelData.windSpeed) м/с, направление ветра \(weatherTodayModelData.windDegree). Shared by WeatherApp"
        } else {
            return "Share failed. Error: \(String(describing: error ?? .none))"
        }
        
    }
    
    func emptyData() -> WeatherTodayModelData {
        return .emptyData()
    }
}
