//
//  ViewController.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let clockView = ClockView(frame: .zero)
    let batteryIndicatorView = BatteryIndicatorView(frame: .zero)
    
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        startTimer()
        setupView()
    }

    private func setupView() {
        view.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(batteryIndicatorView)
        batteryIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clockView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clockView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            clockView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            clockView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            batteryIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            batteryIndicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            batteryIndicatorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            batteryIndicatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

extension ViewController {
    
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
        }
    }
    
    func updateBackgroundColor() {
        let currentTime = Date()
        if dinnerRange.contains(currentTime) {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .black
        }
    }
    
    func updateBrightness() {
        let currentTime = Date()
        if workTimeRange.contains(currentTime) {
            UIScreen.main.brightness = 0.9
        } else {
            UIScreen.main.brightness = 0
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
