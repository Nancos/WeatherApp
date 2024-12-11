//
//  WeatherWeekTableViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 9.12.24.
//

import UIKit

class WeekTableView: UITableView, UITableViewDelegate {

    private var dictionaryCountHoursInDay: [String:Int] = [:]
    
    let apiManager = APIManager.shared
    
    private var weatherData: WeatherData? {
        didSet {
            getValueForTable()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        settingsTable()
        getWeatherData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private extension WeekTableView {
    
    func getWeatherData() {
        Task(){
            do {
                weatherData = try await apiManager.getWeather()
            }
            catch {
                print(error)
            }
        }
    }
    
    func getValueForTable() {
        
        var array: [String] = []
        
        for i in 0..<weatherData!.cnt {
            array.append(weatherData!.list[i].dtTxt)
        }
        
        // отрезаем время, оставляем только дату
        array = array.map { $0.components(separatedBy: " ")[0] }

        let countedSet = NSCountedSet(array: array)
        
        //
        for (key, value) in countedSet.dictionary {
            let keyValue = key as! String
            dictionaryCountHoursInDay[keyValue] = value
        }
        
    }
    
}


private extension WeekTableView {
    
    func settingsTable() {
        separatorStyle = .none
        backgroundColor = .weatherWeekBackground
        register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseId)
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
    }
    
    func configure(cell: inout WeatherCell, for indexPath: IndexPath) {
         
        let rowIndex = getRowIndex(for: indexPath)
         
        let image = UIImage(named: weatherData?.list[rowIndex].weather.first?.icon.rawValue ?? "50d")!
        let time = weatherData?.list[rowIndex].dtTxt.dropFirst(11).dropLast(3) ?? "---"
        let temp = round(weatherData?.list[rowIndex].main.temp ?? 0)
        let sky = weatherData?.list[rowIndex].weather.first?.description.rawValue ?? " - "
        
        cell.configure(image: image, time: String(time), clouds: sky, temperature: String(temp))
    }
    
    func getRowIndex(for indexPath: IndexPath) -> Int {
        var rowIndex: Int = 0
        
        if indexPath.section == 0 {
            rowIndex = indexPath.row
        } else if indexPath.section == 1 {
            rowIndex = indexPath.row + dictionaryCountHoursInDay.sorted(by: <)[0].value
        } else {
            rowIndex = indexPath.row + dictionaryCountHoursInDay.sorted(by: <)[0].value + ((indexPath.section-1)*8)
        }
        
        return rowIndex
    }
    
}


// MARK: - Delegate, DataSource -

extension WeekTableView: UITableViewDataSource {
    
    // Кол-во секций назначаем исходя из кол-во уникальных дат
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionaryCountHoursInDay.count
    }
    // Название секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        // указываем текущий формат даты
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // получаем Date формат из текстового варианта
        let date = dateFormatter.date(from: dictionaryCountHoursInDay.sorted(by: <)[section].key)!
        // выбираем в каком виде будет title section
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        // возвращаем день недели
        return dateFormatter.string(from: date)
    }
    
    // измене
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 18)
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    // Количество строк в секции назначаем исходя из кол-ва
    // повторяющихся элементов для каждой даты
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryCountHoursInDay.sorted(by: <)[section].value
    }
    // создаем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        var cell: WeatherCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseId) as? WeatherCell {
            cell = reuseCell
        }
        else
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: WeatherCell.reuseId) as!
            WeatherCell
        }
        configure(cell: &cell, for: indexPath)
        return cell
        
    }
}
 
// взял с stackoverflow
// нахождение одинаковых элементов и их кол-во
extension NSCountedSet {
    var occurences: [(object: Any, count: Int)] { map { ($0, count(for: $0))} }
    var dictionary: [AnyHashable: Int] {
        reduce(into: [:]) {
            guard let key = $1 as? AnyHashable else { return }
            $0[key] = count(for: key)
        }
    }
}
