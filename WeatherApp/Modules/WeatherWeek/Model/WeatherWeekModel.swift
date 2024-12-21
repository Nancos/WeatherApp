//
//  Model.swift
//  WeatherApp
//
//  Created by MacBook Air on 16.12.24.
//

import Foundation

class WeatherWeekModel {
    
    private let apiManager = APIManager.shared
    
    func getWeatherData(latitude: Float, longitude: Float, complition: @escaping (WeatherWeekModelData?, Error?) -> Void) {
        
        apiManager.latitude = latitude
        apiManager.longitude = longitude
        
        apiManager.getWeather{ [weak self] weatherData, error in
            
            guard let `self` else { return }
            
            guard error == nil else {
                return complition(nil, error)
            }
            
            guard let weatherData else {
                return complition(nil, nil)
            }
            
            var date = [String]()
            var icon = [String]()
            var time = [String]()
            var description = [String]()
            var temp = [String]()
            
            for i in 0..<weatherData.cnt {
                date.append(String(weatherData.list[i].dtTxt.split(separator: " ")[0]))
                icon.append(weatherData.list[i].weather[0].icon.rawValue)
                time.append(String(weatherData.list[i].dtTxt.split(separator: " ")[1].dropLast(3)))
                description.append(weatherData.list[i].weather[0].description.rawValue)
                temp.append(String(Int(weatherData.list[i].main.temp.rounded())) + "°С" )
            }
            
            guard let dictionaryCountHoursInDay = getDictionaryCountHoursInDay(array: date) else { return complition(nil, error)}
            let titlesForTableView = getTitlesForTableView(dictionaryCountHoursInDay: dictionaryCountHoursInDay)
            
            return complition(WeatherWeekModelData(city: weatherData.city.name,
                                                   date: date,
                                                   icon: icon,
                                                   time: time,
                                                   description: description,
                                                   temp: temp,
                                                   dictionaryCountHoursInDay: dictionaryCountHoursInDay,
                                                   titlesForTableView: titlesForTableView), nil)
        }
    }
}


private extension WeatherWeekModel {
    
    func getDictionaryCountHoursInDay(array: [String]) -> [String: Int]?{
        var dictionaryCountHoursInDay: [String: Int] = [:]
        let countedSet = NSCountedSet(array: array)
        
        for (key, value) in countedSet.dictionary {
            guard let keyValue = key as? String else { return nil }
            dictionaryCountHoursInDay[keyValue] = value
        }
        return dictionaryCountHoursInDay
    }
    
    func getTitlesForTableView(dictionaryCountHoursInDay: [String: Int]) -> [String] {
        var titlesForTableView: [String] = []
        let dateFormatter = DateFormatter()
        
        for i in 0..<dictionaryCountHoursInDay.count {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dictionaryCountHoursInDay.sorted(by: <)[i].key) else { return ["error"] }
            dateFormatter.dateFormat = "EEEE, d MMM yyyy"
            titlesForTableView.append(dateFormatter.string(from: date))
        }
        return titlesForTableView
    }
}

private extension NSCountedSet {
    var dictionary: [AnyHashable: Int] {
        reduce(into: [:]) {
            guard let key = $1 as? AnyHashable else { return }
            $0[key] = count(for: key)
        }
    }
}
