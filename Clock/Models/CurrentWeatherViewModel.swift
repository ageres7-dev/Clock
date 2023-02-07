//
//  CurrentWeatherViewModel.swift
//  Clock
//
//  Created by Sergey Dolgikh on 05.02.2023.
//

import Foundation

struct CurrentWeatherViewModel {
    let iconName: String
    let temperature: String
    var locationName: String?
}

extension CurrentWeatherViewModel {
    init(from model: CurrentWeather) {
        if let temp = model.main?.temp {
            temperature = " \(lround(temp))º"
        } else {
            temperature = " –"
        }
        locationName = model.name
        
        let result: String
        switch model.weather?.first?.icon {
        case "01d": result = "sun.max"
        case "01n": result = "moon.stars"
        case "02d": result = "cloud.sun"
        case "02n": result = "cloud.moon"
        case "03d": result = "cloud"
        case "03n": result = "cloud"
        case "04d": result = "smoke"
        case "04n": result = "smoke"
        case "09d": result = "cloud.rain"
        case "09n": result = "cloud.rain"
        case "10d": result = "cloud.sun.rain"
        case "10n": result = "cloud.moon.rain"
        case "11d": result = "cloud.bolt.rain"
        case "11n": result = "cloud.bolt.rain"
        case "13d": result = "snow"
        case "13n": result = "snow"
        case "50d": result = "smoke"
        case "50n": result = "smoke"
        default: result = ""
        }
        iconName = result
    }

}
