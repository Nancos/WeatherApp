//
//  APIManager.swift
//  WeatherApp
//
//  Created by MacBook Air on 11.12.24.
//


import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    var latitude: Float?
    var longitude: Float?
    private var units = "metric"
    private var language = "en"
    
    private var apiKey = "e386440b06932e13b5a53f24842ae9da"
    
    //private var weatherData: WeatherData?
    
    func getWeather(complition: @escaping (WeatherData?, Error?) -> Void) {
        guard let latitude, let longitude else { return }
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)&lang=\(language)"
        guard let url = URL(string: urlString) else {
            return complition(nil, URLError(.badURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
                guard error == nil else { return complition(nil, error) }
                guard let data else { return complition(nil, URLError(.badServerResponse)) }
                do {
                    let data = try JSONDecoder().decode(WeatherData.self, from: data)
                    complition(data, nil)
                }
                catch let errorData {
                    complition(nil, errorData)
                }
        }.resume()
    }
}
