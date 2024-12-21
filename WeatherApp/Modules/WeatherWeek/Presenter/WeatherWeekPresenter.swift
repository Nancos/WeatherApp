//
//  Presenter.swift
//  WeatherApp
//
//  Created by MacBook Air on 16.12.24.
//

import Foundation
import UIKit

protocol WeatherWeekDelegate {
    func configureView()
    func showAlert(title: String, message: String,
                   firstActionTitle: String, firstActionHandler: @escaping (() -> Void),
                   secondActionTitle: String?, secondActionHandler: @escaping (() -> Void))
}

class WeatherWeekPresenter {
    
    private let locationManager = LocationManager.shared
    private let model = WeatherWeekModel()
    var delegate: WeatherWeekDelegate?
    
    var weatherWeekModelData: WeatherWeekModelData?
}


extension WeatherWeekPresenter {
    
    func getLocation() {
        locationManager.getUserLocation(
            successCompletion: { [weak self] location in
                self?.getWeatherWeekModelData(latitude: Float(location.coordinate.latitude),
                                              longitude: Float(location.coordinate.longitude))
            },
            failureCompletion: { [weak self] location in
                self?.getWeatherWeekModelData(latitude: Float(location.coordinate.latitude),
                                              longitude: Float(location.coordinate.longitude))
                
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
                        self?.delegate?.showAlert(title: "Can't open settings",
                                                  message: "Нам не удалось получить данные вашей геопозиции",
                                                  firstActionTitle: "ok", firstActionHandler: {},
                                                  secondActionTitle: nil, secondActionHandler: {})
                    })
            })
    }
    
    private func getWeatherWeekModelData(latitude: Float, longitude: Float) {
        model.getWeatherData(latitude: latitude, longitude: longitude) { [weak self] weatherWeekModelData, error in
            
            guard let `self`, let delegate else { return }
            
            guard error == nil else {
                self.weatherWeekModelData = self.emptyData()
                delegate.configureView()
                return delegate.showAlert(title: "Error",
                                          message: String(describing: error ?? .none),
                                          firstActionTitle: "Ok",
                                          firstActionHandler: {},
                                          secondActionTitle: nil, secondActionHandler: {})
            }
            
            guard let weatherWeekModelData else {
                self.weatherWeekModelData = self.emptyData()
                delegate.configureView()
                return delegate.showAlert(title: "Error",
                                          message: "promlem's...",
                                          firstActionTitle: "Ok",
                                          firstActionHandler: {},
                                          secondActionTitle: nil, secondActionHandler: {})
            }
            
            self.weatherWeekModelData = weatherWeekModelData
            delegate.configureView()
        }
    }
    
    func emptyData() -> WeatherWeekModelData {
        return .createEmpty()
    }
}

//MARK: - get for table -

extension WeatherWeekPresenter {
    
    func getCityName() -> String {
        return weatherWeekModelData?.city ?? "Error"
    }
    
    func getNumberOfSections() -> Int {
        return weatherWeekModelData?.dictionaryCountHoursInDay.count ?? 1
    }
    
    func getTitlesForTableView(for section: Int) -> String {
        return weatherWeekModelData?.titlesForTableView[section] ?? "Error"
    }
    
    func getNumberOfSectionRows(for section: Int) -> Int {
        return weatherWeekModelData?.dictionaryCountHoursInDay.sorted(by: <)[section].value ?? 1
    }
    
    func getRowIndex(for indexPath: IndexPath) -> Int {
        var rowIndex: Int = 0
        
        if indexPath.section == 0 {
            rowIndex = indexPath.row
        } else if indexPath.section == 1 {
            rowIndex = indexPath.row + (weatherWeekModelData?.dictionaryCountHoursInDay.sorted(by: <)[0].value ?? 1)
        } else {
            rowIndex = indexPath.row + (weatherWeekModelData?.dictionaryCountHoursInDay.sorted(by: <)[0].value ?? 1) + ((indexPath.section-1)*8)
        }
        return rowIndex
    }
    
    func getImageForCell(for rowIndex: Int) -> UIImage? {
        return UIImage(named: weatherWeekModelData?.icon[rowIndex] ?? "11n")
    }
    
    func getTimeForCell(for rowIndex: Int) -> String {
        return weatherWeekModelData?.time[rowIndex] ?? "Error"
    }
    
    func getCloudsForCell(for rowIndex: Int) -> String {
        return weatherWeekModelData?.description[rowIndex] ?? "---"
    }
    
    func getTempForCell(for rowIndex: Int) -> String {
        return weatherWeekModelData?.temp[rowIndex] ?? "---"
    }
}
