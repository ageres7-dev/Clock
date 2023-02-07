//
//  BatteryView.swift
//  Clock
//
//  Created by Sergey Dolgikh on 08.02.2023.
//

import UIKit


class BatteryView: UIView {
    let batteryImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named: "battery.0")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var batteryState: UIDevice.BatteryState {
        UIDevice.current.batteryState
    }
    
    var batteryLevel: Float {
        UIDevice.current.batteryLevel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIDevice.current.isBatteryMonitoringEnabled = true
        setupConstraints()
        updateFromChargeStatus()
        subscribe()
        updateIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        UIDevice.current.isBatteryMonitoringEnabled = true
        setupConstraints()
        updateFromChargeStatus()
        subscribe()
        updateIndicator()
    }
    
    private func setupConstraints() {
        addSubview(batteryImageView)
        NSLayoutConstraint.activate([
            batteryImageView.topAnchor.constraint(equalTo: topAnchor),
            batteryImageView.leftAnchor.constraint(equalTo: leftAnchor),
            batteryImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            batteryImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func subscribe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
        updateIndicator()
    }
    
    private func updateIndicator() {
        let imageName: String
        switch batteryLevel {
        case (..<0.125):
            imageName = "battery.0"
        case (0.125..<0.375):
            imageName = "battery.25"
        case (0.375..<0.625):
            imageName = "battery.50"
        case (0.625..<0.875):
            imageName = "battery.75"
        default:
            imageName = "battery.100"
        }
        batteryImageView.image = UIImage(named: imageName)
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        updateFromChargeStatus()
    }

    func updateFromChargeStatus() {
        switch batteryState {
        case .unplugged:
            batteryImageView.isHidden = false
        default:
            batteryImageView.isHidden = true
        }
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0.0, *)
struct BatteryView_Preview: PreviewProvider {
    static var previews: some View {
        let view = BatteryView(frame: .zero)
        view.backgroundColor = .gray
        return ViewControllerRepresentable(view: view)
            .previewLayout(.fixed(width: 150, height: 150))
            .padding(.vertical, 440)
    }
}
#endif
