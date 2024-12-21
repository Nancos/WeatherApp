//
//  WeatherWeekModelData.swift
//  WeatherApp
//
//  Created by MacBook Air on 18.12.24.
//

struct WeatherWeekModelData {
    
    let city: String
    let date: [String]
    let icon: [String]
    let time: [String]
    let description: [String]
    let temp: [String]
    let dictionaryCountHoursInDay: [String:Int]
    let titlesForTableView: [String]
    
    internal init(city: String, date: [String] , icon: [String], time: [String], description: [String], temp: [String], dictionaryCountHoursInDay: [String:Int], titlesForTableView: [String]) {
        self.city = city
        self.date = date
        self.icon = icon
        self.time = time
        self.description = description
        self.temp = temp
        self.dictionaryCountHoursInDay = dictionaryCountHoursInDay
        self.titlesForTableView = titlesForTableView
    }
    
    static func createEmpty() -> WeatherWeekModelData {
        return WeatherWeekModelData(city: "Error",
                                    date: ["eroor"],
                                    icon: ["50n"],
                                    time: ["---"],
                                    description: ["---"],
                                    temp: [""],
                                    dictionaryCountHoursInDay: ["": 1],
                                    titlesForTableView: ["error"])
    }
}
