//
//  WeatherTodayModel.swift
//  WeatherApp
//
//  Created by MacBook Air on 16.12.24.
//
import Foundation

class WeatherTodayModel {
    
    private let apiManager = APIManager.shared
    
    func getWeatherData(latitude: Float, longitude: Float, complition: @escaping (WeatherTodayModelData?, Error?) -> Void) {
        
        apiManager.latitude = latitude
        apiManager.longitude = longitude
        
        apiManager.getWeather { [weak self] weatherData, error in
            guard let `self` else { return }
            
            guard error == nil else { return complition(nil, error) }
            
            guard let weatherData,
                  let temp = weatherData.list.first?.main.temp,
                  let imageString = weatherData.list.first?.weather.first?.icon.rawValue,
                  let descriptionClouds = weatherData.list.first?.weather.first?.description.rawValue,
                  let clouds = weatherData.list.first?.clouds.all,
                  let windSpeed = weatherData.list.first?.wind.speed,
                  let windDegree = weatherData.list.first?.wind.deg,
                  let pressure = weatherData.list.first?.main.pressure,
                  let humidity = weatherData.list.first?.main.humidity
            else { return complition(nil, nil) }
            
            return complition(WeatherTodayModelData(city: weatherData.city.name,
                                                    country: weatherData.city.country,
                                                    temp: Int(round(temp)) ,
                                                    imageString: imageString,
                                                    descriptionClouds: descriptionClouds,
                                                    clouds: clouds,
                                                    windSpeed: windSpeed,
                                                    windDegree: self.degToCompass(deg: windDegree),
                                                    pressure: Int(pressure),
                                                    humidity: humidity), nil)
        }
    }

    private func degToCompass(deg: Int) -> String {
        let val = Int((Double(deg) / 22.5) + 0.5);
        let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        return arr[(val % 16)]
    }
}

