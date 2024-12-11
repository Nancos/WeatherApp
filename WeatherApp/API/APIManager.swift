//
//  APIManager.swift
//  WeatherApp
//
//  Created by MacBook Air on 11.12.24.
//


import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    var latitude: Float = 55.1905
    var longitude: Float = 30.2033
    var units = "metric"
    var language = "en"
    
    var apiKey = "e386440b06932e13b5a53f24842ae9da"
    
    var weatherData: WeatherData?
    
    func getWeather() async throws -> WeatherData {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)&lang=\(language)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw error
            
        }
    }
}
