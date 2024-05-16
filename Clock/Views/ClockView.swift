//
//  ClockView.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit


class ClockView: UIView {
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 1000)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
 
    func update(time: Date) {
        timeLabel.text = formatter.string(from: time)
    }
    
    private func setupConstraints() {
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: leftAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}


//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//@available(iOS 13.0.0, *)
//struct MainTitleView_Preview: PreviewProvider {
//    static var previews: some View {
//        let view = ClockView(frame: .zero)
//        view.backgroundColor = .red
//
//        return ViewControllerRepresentable(view: view)
//            .previewLayout(.fixed(width: 150, height: 150))
//            .padding(.vertical, 300)
//    }
//}
//#endif
