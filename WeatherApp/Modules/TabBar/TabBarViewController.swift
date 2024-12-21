//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 9.12.24.
//

import UIKit
import CoreLocation

class TabBarViewController: UITabBarController {
    
    // buttons
    private lazy var buttonWeatherToday = getButton(icon: "Today", tag: 0, opacity: 1)
    private lazy var buttonWeatherWeek = getButton(icon: "Week", tag: 1)
    private lazy var customBar = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}


// MARK: - Setup -

private extension TabBarViewController {
    
    func setupViews() {
        tabBar.isHidden = true
        setViewControllers([WeatherTodayViewController(), WeatherWeekViewController()], animated: true)
        setupCustomBar()
    }
    
    func setupCustomBar() {
        customBar.axis = .horizontal
        customBar.distribution = .equalSpacing
        customBar.alignment = .center
        customBar.backgroundColor = UIColor(named: "TabBar")
        customBar.frame = CGRect(x: 20, y: view.frame.height - 90, width: view.frame.width - 40, height: 50)
        customBar.layer.cornerRadius = 25
        
        customBar.addArrangedSubview(UIView())
        customBar.addArrangedSubview(buttonWeatherToday)
        customBar.addArrangedSubview(buttonWeatherWeek)
        customBar.addArrangedSubview(UIView())
        
        view.addSubview(customBar)
    }
}


// MARK: = Methods -


private extension TabBarViewController {
    
    @objc func tapButton(sender: UIButton) {
        self.selectedIndex = sender.tag
        setOpacity(tag: sender.tag)
    }
    
    func setOpacity(tag: Int) {
        [buttonWeatherToday, buttonWeatherWeek].forEach{
            if $0.tag != tag {
                $0.layer.opacity = 0.3
            } else {
                $0.layer.opacity = 1
            }
        }
    }
    
    func getButton(icon: String, tag: Int, opacity: Float = 0.3) -> UIButton {
        return {
            let image = UIImageView()
            image.image = UIImage(named: icon)
            $0.addSubview(image)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.widthAnchor.constraint(equalToConstant: 32).isActive = true
            image.heightAnchor.constraint(equalToConstant: 32).isActive = true
            $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            $0.layer.opacity = opacity
            $0.tag = tag
            return $0
        }(UIButton())
    }
}
