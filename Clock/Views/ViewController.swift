//
//  ViewController.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    let clockView = ClockView(frame: .zero)
    let weatherView = WeatherView(frame: .zero)
    let batteryIcon = BatteryView(frame: .zero)
    
    let goSettingsButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "location.slash"), for: .normal)
    
        return button
    }()
    
    private let networkManager = NetworkManager.shared
    
    private let locationManager = CLLocationManager()
    private var statusLocationManager: CLAuthorizationStatus?
    private var currentLocation: CLLocation?
    private var dateLastUpdateWeather: Date?
    
    private var isLight = true
    private var tintColor: UIColor = .black
    private var backgroundColor: UIColor = .white
    
    ///15 минут
    private let minTimeIntervalUpdateCurrentWeather = TimeInterval(60 * 15)
    
    private var isAllowUpdateWeather: Bool {
        guard let dateLastUpdateWeather else { return true }
        let currentDate = Date()
        let intervalSinceLastUpdateCurrentWeather = currentDate.timeIntervalSince(dateLastUpdateWeather)
        
        return intervalSinceLastUpdateCurrentWeather > minTimeIntervalUpdateCurrentWeather
    }
    
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        locationManager.delegate = self
        clockView.update(time: Date())
        updateTintColor()
        updateBackgroundColor()
        updateBrightness()
        startTimer()
        setupView()
        setupGoSettingsButton()
        addViewAction()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }

    private func setupGoSettingsButton() {
        goSettingsButton.isHidden = true
        goSettingsButton.addTarget(
            self,
            action: #selector(goSettingAction),
            for: .touchUpInside
        )
    }
    private func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherView)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goSettingsButton)
        goSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(batteryIcon)
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clockView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clockView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clockView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            clockView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            weatherView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            weatherView.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            
            goSettingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            goSettingsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            goSettingsButton.heightAnchor.constraint(equalToConstant: 24),
            goSettingsButton.widthAnchor.constraint(equalToConstant: 24),
            
            batteryIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            batteryIcon.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            batteryIcon.heightAnchor.constraint(equalToConstant: 24),
            batteryIcon.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func goSettingAction() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func applicationDidBecomeActive() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension ViewController {
    
    var dinnerAlertRange: ClosedRange<Date> {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        dateComponents.hour = 12
        dateComponents.minute = 59
        let startDinner = dateComponents.date
        dateComponents.hour = 13
        dateComponents.minute = 0
        let endDinner = dateComponents.date

        guard let startDinner, let endDinner else { return Date()...Date() }

        return startDinner...endDinner
    }
    
    var dinnerRange: ClosedRange<Date> {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        dateComponents.hour = 13
        dateComponents.minute = 0
        let startDinner = dateComponents.date
        dateComponents.hour = 14
        let endDinner = dateComponents.date

        guard let startDinner, let endDinner else { return Date()...Date() }

        return startDinner...endDinner
    }
    
    var endWorkAlertTimeRange: ClosedRange<Date> {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        dateComponents.hour = 18
        dateComponents.minute = 55
        let start = dateComponents.date
        
        dateComponents.hour = 20
        dateComponents.minute = 00
        let end = dateComponents.date

        guard let start, let end else { return Date()...Date() }

        return start...end
    }
    
    var workTimeRange: ClosedRange<Date> {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        dateComponents.hour = 10
        dateComponents.minute = 0
        let startDinner = dateComponents.date
        dateComponents.hour = 19
        let endDinner = dateComponents.date

        guard let startDinner, let endDinner else { return Date()...Date() }

        return startDinner...endDinner
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.clockView.update(time: Date())
            self?.updateBackgroundColor()
            self?.updateBrightness()
            self?.updateWether()
        }
    }
    
    func updateBackgroundColor() {
        let currentTime = Date()
        if dinnerRange.contains(currentTime) {
            view.backgroundColor = .red
        } else if dinnerAlertRange.contains(currentTime) || endWorkAlertTimeRange.contains(currentTime) {
            view.backgroundColor = getRandomColor()
        } else {
            view.backgroundColor = backgroundColor
        }
    }
    
    func addViewAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeColor))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func changeColor() {
        isLight.toggle()
        tintColor = isLight ? .black : .white
        backgroundColor = isLight ? .white : .black
        updateTintColor()
        updateBackgroundColor()
    }
    
    func updateTintColor() {
        view.backgroundColor = backgroundColor
        weatherView.setColor(tintColor)
        clockView.setColor(tintColor)
        batteryIcon.setColor(tintColor)
    }
    
    func updateBrightness() {
//        let currentTime = Date()
//        if workTimeRange.contains(currentTime) {
//            UIScreen.main.brightness = 0.9
//        } else {
//            UIScreen.main.brightness = 0
//        }
    }
    
    func updateWether() {
        let allowedStatuses: [CLAuthorizationStatus?] = [.authorizedAlways, .authorizedWhenInUse]
        guard
            let currentLocation,
            allowedStatuses.contains(statusLocationManager),
            isAllowUpdateWeather
        else { return }
        
        dateLastUpdateWeather = Date()
        let url = URLManager.urlCurrentWeatherFrom(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )
        guard let url else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.networkManager.fetchCurrentWeather(from: url) { weather in
                let viewModel = CurrentWeatherViewModel(from: weather)
                self.weatherView.update(from: viewModel)
                self.weatherView.stopActivity()
            }
        }
    }
    
    func getRandomColor() -> UIColor {
        UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            handlerLocationManager(status: manager.authorizationStatus) 
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handlerLocationManager(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        updateWether()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find location: \(error.localizedDescription)")
    }
    
    private func handlerLocationManager(status: CLAuthorizationStatus) {
        statusLocationManager = status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
            goSettingsButton.isHidden = true
            weatherView.isHidden = false
            weatherView.startActivity()
        default:
            goSettingsButton.isHidden = false
            weatherView.isHidden = true
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainViewController_Preview: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        
        let view = UIView()
        view.backgroundColor = .red
        
        return VCRepresentable(vc: ViewController())
//            .previewLayout(.fixed(width: 200, height: 200))
//            .padding(6)
    }
}
#endif
