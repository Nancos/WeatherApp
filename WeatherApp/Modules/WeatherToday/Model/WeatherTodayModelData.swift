//
//  WeatherTodayModelData.swift
//  WeatherApp
//
//  Created by MacBook Air on 16.12.24.
//

struct WeatherTodayModelData {
    
    let city: String
    let country: String
    let temp: String
    let imageString: String
    let descriptionClouds: String
    let clouds: String
    let cloudsImageString: String = "Clouds"
    let windSpeed: String
    let windSpeedImageString: String = "WindSpeed"
    let windDegree: String
    let windDegreeImageString: String = "WindDegree"
    let pressure: String
    let pressureImageString: String = "Pressure"
    let humidity: String
    let humidityImageString: String = "Humidity"
    
    internal init(city: String, country: String, temp: Int, imageString: String, descriptionClouds: String, clouds: Int, windSpeed: Double, windDegree: String, pressure: Int, humidity: Int) {
        self.city = city
        self.country = country
        self.temp = "\(temp)°C"
        self.imageString = imageString
        self.descriptionClouds = descriptionClouds
        self.clouds = "\(clouds)" + "%"
        self.windSpeed = "\(windSpeed)" + "m/s"
        self.windDegree = "\(windDegree)"
        self.pressure = "\(pressure)" + "hPa"
        self.humidity = "\(humidity)"  + "%"
    }
    
    static func emptyData() -> WeatherTodayModelData {
        return WeatherTodayModelData(city: "Error",
                              country: "Error",
                              temp: 0,
                              imageString: "-",
                              descriptionClouds: "-",
                              clouds: 0,
                              windSpeed: 0,
                              windDegree: "-",
                              pressure: 0,
                              humidity: 0)
    }
}
