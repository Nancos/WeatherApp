//
//  WeatherWeekViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 14.12.24.
//

import UIKit

class WeatherWeekViewController: UIViewController {
   
    private let topBar = NavigationBarViewController()
    private let presenter = WeatherWeekPresenter()
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        presenter.getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UITableViewDelegate -

extension WeatherWeekViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 18)
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfSectionRows(for: section)
    }
    
}

// MARK: - UITableViewDataSource-

extension WeatherWeekViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.getTitlesForTableView(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WeatherCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseId) as? WeatherCell {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: WeatherCell.reuseId) as! WeatherCell
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    func configure(cell: inout WeatherCell, for indexPath: IndexPath) {
        let rowIndex = presenter.getRowIndex(for: indexPath)
        guard let image = presenter.getImageForCell(for: rowIndex) else { return }
        cell.configure(image: image,
                       time: presenter.getTimeForCell(for: rowIndex),
                       clouds: presenter.getCloudsForCell(for: rowIndex),
                       temperature: presenter.getTempForCell(for: rowIndex))
    }
}

// MARK: - WeatherWeekDelegate -

extension WeatherWeekViewController: WeatherWeekDelegate {
    
    func configureView() {
        DispatchQueue.main.async {
            self.configure()
        }
    }
    
    func showAlert(title: String, message: String,
                   firstActionTitle: String, firstActionHandler: @escaping (() -> Void),
                   secondActionTitle: String?, secondActionHandler: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: firstActionTitle,
                                          style: .default,
                                          handler: { _ in firstActionHandler() }))
            if let secondActionTitle {
                alert.addAction(UIAlertAction(title: secondActionTitle,
                                              style: .default,
                                              handler: { _ in secondActionHandler() }))
            }
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Configue View -

extension WeatherWeekViewController {
    
    func configure() {
        view.backgroundColor = UIColor(named: "WeatherWeekBackground")
        setupTopBar()
        setupTable()
        setupConstraints()
    }
    
    func setupTopBar() {
        topBar.configure(text: presenter.getCityName())
        
        view.addSubview(topBar)
    }
    
    func setupTable() {
        table.separatorStyle = .none
        table.backgroundColor = .weatherWeekBackground
        table.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseId)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        
        view.addSubview(table)
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
