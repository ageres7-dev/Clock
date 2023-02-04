//
//  ClockView.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//

import UIKit


class ClockView: UIView {
    var delegate: ChangeColorProtocol?
    var timer: Timer?
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 300)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        startTimer()
        updateBackgroundColor()
        updateTime()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        startTimer()
        updateBackgroundColor()
        updateTime()
        setupConstraints()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTime()
            self?.updateBackgroundColor()
        }
    }
    
    @objc func timerAction() {
        
    }
    
    func updateTime() {
        timeLabel.text = formatter.string(from: Date())
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
    
    func updateBackgroundColor() {
        let currentTime = Date()
        if dinnerRange.contains(currentTime) {
            delegate?.change(color: .red)
        } else {
            delegate?.change(color: .black)
        }
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
