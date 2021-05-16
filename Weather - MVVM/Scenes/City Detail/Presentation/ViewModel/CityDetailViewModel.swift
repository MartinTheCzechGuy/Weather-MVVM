//
//  CityDetailViewModel.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import Foundation
import Combine

final class CityDetailViewModel: CityDetailViewModelType {
    
    // Output
    var city: String
    var weatherCode: WeatherCode
    var weatherDescription: String
    var temperature: Double
    var pressure: Double
    var humidity: Double

    init(
        city: String,
        weatherCode: WeatherCode,
        weatherDescription: String,
        temperature: Double,
        pressure: Double,
        humidity: Double
    ) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        self.city = city
        self.weatherCode = weatherCode
        self.weatherDescription = weatherDescription
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
    }
    
}
