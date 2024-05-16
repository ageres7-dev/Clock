//
//  WeatherView.swift
//  Clock
//
//  Created by Sergey Dolgikh on 05.02.2023.
//

import UIKit


class WeatherView: UIView {

    let icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        
        return label
    }()
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    func update(from model: CurrentWeatherViewModel) {
        temperatureLabel.text = model.temperature
        icon.image = UIImage(named: model.iconName)
        secondLabel.text = model.description?.capitalizingFirstLetter()
    }
    
    func startActivity() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopActivity() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    private func setupConstraints() {
        addSubview(temperatureLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(secondLabel)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let temperatureLabelLeftAnchor = temperatureLabel.leftAnchor.constraint(
            greaterThanOrEqualTo: icon.rightAnchor
        )
        temperatureLabelLeftAnchor.priority = .defaultLow
        
        let locationLabelLeftAnchor = secondLabel.leftAnchor.constraint(
            greaterThanOrEqualTo: leftAnchor
        )
        temperatureLabelLeftAnchor.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            icon.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
            icon.bottomAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: -2),
            icon.rightAnchor.constraint(equalTo: temperatureLabel.leftAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            temperatureLabelLeftAnchor,
            temperatureLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            secondLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
            secondLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationLabelLeftAnchor,
            secondLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
        ])
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0.0, *)
struct MainTitleView_Preview: PreviewProvider {
    static var previews: some View {
        let view = WeatherView(frame: .zero)
        view.backgroundColor = .red
        view.temperatureLabel.text = "22º"

        return ViewControllerRepresentable(view: view)
            .previewLayout(.fixed(width: 150, height: 150))
            .padding(.vertical, 300)
    }
}
#endif
