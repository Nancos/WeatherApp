//
//  WeatherTodayViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 9.12.24.
//

import UIKit
import CoreLocation

class WeatherTodayViewController: UIViewController {
    
    private let topBar = NavigationBarViewController()
    private let weatherStackView = WeatherStackView()
    private let coupleCustomView = CoupleCustomView()
    private let shareButton = UIButton()
    
    private let presenter = WeatherTodayPresenter()
    
    private var sharedString: String?
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        presenter.delegate = self
        presenter.getLocation()
    }

}

extension WeatherTodayViewController: WeatherTodayDelegate {
    
    func configureView(with weatherTodayModelData: WeatherTodayModelData, sharedString: String) {
        DispatchQueue.main.async {
            self.sharedString = sharedString
            
            self.weatherStackView.configure(imageString: weatherTodayModelData.imageString,
                                       country: weatherTodayModelData.city + ", " + weatherTodayModelData.country,
                                       temperature: String(weatherTodayModelData.temp) + " | " + String(weatherTodayModelData.descriptionClouds))
            
            self.coupleCustomView.configure(clouds: weatherTodayModelData.clouds,
                                       cloudsImageString: weatherTodayModelData.cloudsImageString,
                                       pressure: weatherTodayModelData.pressure,
                                       pressureImageString: weatherTodayModelData.pressureImageString,
                                       humidity: weatherTodayModelData.humidity,
                                       humidityImageString: weatherTodayModelData.humidityImageString,
                                       windSpeed: weatherTodayModelData.windSpeed,
                                       windSpeedImageString: weatherTodayModelData.windSpeedImageString,
                                       windDegree: weatherTodayModelData.windDegree,
                                       windDegreeImageString: weatherTodayModelData.windDegreeImageString)
        }
    }
    
    func showAlert(title: String, message: String,
                   firstActionTitle: String, firstActionHandler: @escaping (() -> Void),
                   secondActionTitle: String?, secondActionHandler: @escaping (() -> Void) ) {
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


private extension WeatherTodayViewController {
    
    func setupSubviews() {
        setupView()
        setupTopBar()
        setupHorizontalStackView()
        setupCoupleCustomView()
        setupShareButton()
        
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "WeatherTodayBackground")
    }
    
    func setupTopBar() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.configure(text: "Today")
        
        view.addSubview(topBar)
    }
    
    func setupHorizontalStackView() {
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(weatherStackView)
    }
    
    func setupCoupleCustomView() {
        coupleCustomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(coupleCustomView)
    }
    
    func setupShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.red, for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        shareButton.addTarget(self, action: #selector(showShare), for: .touchUpInside)
        
        view.addSubview(shareButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -1),
            topBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 1),
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            weatherStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            weatherStackView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 80),
            
            coupleCustomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            coupleCustomView.topAnchor.constraint(equalTo: weatherStackView.bottomAnchor, constant: 20),
            
            shareButton.widthAnchor.constraint(equalToConstant: 100),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: coupleCustomView.bottomAnchor, constant: 50)
        ])
    }
}

// MARK: = Share button -

extension WeatherTodayViewController {
    
    @objc func showShare() {
        guard let sharedString else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [sharedString],
                                                              applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
}
