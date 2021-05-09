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
    @Published var city: String
    @Published var weatherDescription: String
    @Published var temperature: Double
    @Published var pressure: Double
    @Published var humidity: Double

    init(
        city: String,
        weatherDescription: String,
        temperature: Double,
        pressure: Double,
        humidity: Double
    ) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        self.city = city
        self.weatherDescription = weatherDescription
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
    }
    
}
