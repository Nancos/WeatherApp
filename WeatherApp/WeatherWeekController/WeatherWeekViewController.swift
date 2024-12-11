//
//  WeatherWeekViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 14.12.24.
//

import UIKit

class WeatherWeekViewController: UIViewController {
    
    private let topBar = StackViewTopBar()
    private let table = WeekTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}


extension WeatherWeekViewController {
    
    func configure() {
        view.backgroundColor = UIColor(named: "WeatherWeekBackground")
        view.addSubview(table)
        setupConstraints()
        
    }
    
    func setupTopBar() {
        topBar.confgure(text: "\n\n5 Day / 3 Hour Forecast")
        
        view.addSubview(topBar)
    }
    
    func setupConstraints() {
        // topBar
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -1),
            topBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 1),
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35) ])
        // table
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100) ])
        
    }
    
    
}
