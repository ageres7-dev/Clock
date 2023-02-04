//
//  BatteryIndicatorView.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit

class BatteryIndicatorView: UIView {
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
    
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        UIDevice.current.isBatteryMonitoringEnabled = true
        setupConstraints()
        updateFromChargeStatus()
        subscribe()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicator()
    }
    
    private func setupConstraints() {
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topAnchor),
            indicatorView.leftAnchor.constraint(equalTo: leftAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorWidthConstraint,
        ])
    }
    
    func subscribe() {
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
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
        updateIndicator()
    }
    
    func updateIndicator() {
        let level = CGFloat(batteryLevel)
        let multiplier = level >= 0 ? level : 0
        let width = frame.width
        indicatorWidthConstraint.constant = width * multiplier
        layoutIfNeeded()
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        updateFromChargeStatus()
    }

    func updateFromChargeStatus() {
        switch batteryState {
        case .unplugged:
            indicatorView.isHidden = false
        default:
            indicatorView.isHidden = true
        }
    }
}


//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//@available(iOS 13.0.0, *)
//struct BatteryIndicatorView_Preview: PreviewProvider {
//    static var previews: some View {
//        let view = BatteryIndicatorView(frame: .zero)
//
//        return ViewControllerRepresentable(view: view)
////            .previewLayout(.fixed(width: 150, height: 150))
////            .padding(.vertical, 300)
//    }
//}
//#endif
