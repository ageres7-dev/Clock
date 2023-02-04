//
//  ViewController.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit

protocol ChangeColorProtocol {
    func change(color: UIColor)
}

class ViewController: UIViewController {
    let clockView = ClockView(frame: .zero)
    
    let batteryIndicatorView = BatteryIndicatorView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        clockView.delegate = self
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

extension ViewController: ChangeColorProtocol {
    func change(color: UIColor) {
        view.backgroundColor = color
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
