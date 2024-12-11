//
//  WeatherTodayViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 9.12.24.
//

import UIKit
import CoreLocation

class WeatherTodayViewController: UIViewController {
    
    private let locationManager = LocationManager.shared
    private let apiManager = APIManager.shared
    
    
    private let topBar = StackViewTopBar()
    private let horizontalStackView = HorizontalStackView()
    private let coupleCustomView = CoupleCustomView()
    
    
    private let shareButton = UIButton()
    private var sharedItems: [Any] = []
    
    
    private var weatherData: WeatherData? {
        didSet {
            setupSubviews()
        }
    }
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "WeatherTodayBackground")
        
        getAuthorizationStatusOfLocation()
        
        locationManager.getUserLocation { location in
            self.apiManager.latitude = Float(location.coordinate.latitude)
            self.apiManager.longitude = Float(location.coordinate.longitude)
        }
        
        Task(){
            do {
                weatherData = try await apiManager.getWeather()
            }
            catch {
                print(error)
            }
        }

    }
    
}

private extension WeatherTodayViewController {
    
    func setupSubviews() {
        
        
        
        configureShareButton()
        configureTopBar()
        configureCoupleCustomView()
        configureHorizontalStackView()
        
        setupConstraints()
    }
    
    func configureShareButton() {
        setShareButton()
        
        let city = weatherData?.city.name ?? "-"
        let country = weatherData?.city.country ?? "-"
        let temp = Int(round(weatherData?.list.first?.main.temp ?? 0))
        let descriptionClouds = weatherData?.list.first?.weather.first?.description.rawValue ?? "-"
        let textArray = [
            weatherData?.list[0].clouds.all.description ?? "-",
            weatherData?.list[0].main.pressure.description ?? "-",
            weatherData?.list[0].main.humidity.description ?? "-",
            weatherData?.list[0].wind.speed.description ?? "-",
            degToCompass(deg: weatherData?.list[0].wind.deg)
        ]
        
        sharedItems = [
            "Сейчас в \(city), \(country) \(temp)°C | \(descriptionClouds), облачно \(textArray[0])%, давление \(textArray[1]) мм Hg, влажность \(textArray[2])%, скорость ветра \(textArray[3]) м/с, направление ветра \(textArray[4]). Shared by WeatherApp"
        ]
        
        view.addSubview(shareButton)
    }
    
    func configureTopBar() {
        topBar.confgure(text: "\n\nToday")
        
        view.addSubview(topBar)
    }
    
    func configureCoupleCustomView() {
        let textArray = [
            weatherData?.list[0].clouds.all.description ?? "-",
            weatherData?.list[0].main.pressure.description ?? "-",
            weatherData?.list[0].main.humidity.description ?? "-",
            weatherData?.list[0].wind.speed.description ?? "-",
            degToCompass(deg: weatherData?.list[0].wind.deg)
        ]
        
        let imageStringArray = [
            "Clouds", "Pressure", "Humidity", "WindSpeed", "WindDegree"
        ]
        
        coupleCustomView.configure(textArray: textArray, imageStringArray: imageStringArray)
        
        view.addSubview(coupleCustomView)
    }
    
    func configureHorizontalStackView() {
        let city = weatherData?.city.name ?? "-"
        let country = weatherData?.city.country ?? "-"
        let temp = Int(round(weatherData?.list.first?.main.temp ?? 0))
        let descriptionClouds = weatherData?.list.first?.weather.first?.description.rawValue ?? "-"
        let image = UIImage(named: weatherData?.list.first?.weather.first?.icon.rawValue ?? "50d")!
        
        
        horizontalStackView.configure(image: image,
                                      country: city + ", " + country,
                                      temperature:  String(temp) + "°C | " + descriptionClouds)
        
        view.addSubview(horizontalStackView)
    }
    
    
    
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -1),
            topBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 1),
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            horizontalStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 80),
            
            coupleCustomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            coupleCustomView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 20),
            
            shareButton.widthAnchor.constraint(equalToConstant: 100),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: coupleCustomView.bottomAnchor, constant: 50)
        ])
    }
}

// MARK: = Share button -

private extension WeatherTodayViewController {
    
    func setShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.red, for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    @objc func share() {
        let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
}


private extension WeatherTodayViewController {
    
    func getAuthorizationStatusOfLocation() {
        switch LocationManager.shared.getAuthorizationStatus() {
        case .restricted, .denied:
            openSettingsAlert()
        default:
            break
        }
    }
    
    func degToCompass(deg: Int?) -> String {
        if deg == nil { return "" } else {
            let val = Int((Double(deg!) / 22.5) + 0.5);
            let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
            return arr[(val % 16)]
        }
    }
    
    func openSettingsAlert() {
        let alertController = UIAlertController (title: "Перейти в настройки?",
                                                 message: "Для обновления данных погоды нам нужно разрешение на использование геопозиции",
                                                 preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки",
                                           style: .default,
                                           handler: { _ in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        })
        
            alertController.addAction(settingsAction)
        
            let cancelAction = UIAlertAction(title: "Закрыть",
                                             style: .default,
                                             handler: {_ in
                self.getAlertCantOpenSettings()
            })
        
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
                                           
    func getAlertCantOpenSettings() {
        let alert = UIAlertController(title: "Can't open settings",
                                        message: "Нам не удалось получить данные вашей геопозиции",
                                        preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ok",
                                        style: .destructive,
                                        handler: nil))
        present(alert, animated: true)
    }
}
