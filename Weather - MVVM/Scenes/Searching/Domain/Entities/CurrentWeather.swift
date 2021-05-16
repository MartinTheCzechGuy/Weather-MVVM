//
//  CurrentWeather.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

struct CurrentWeather {
    let city: String
    let weather: WeatherCode
    let description: String
    let temperature: Double
    let pressure: Double
    let humidity: Double
}

extension CurrentWeather: Hashable {}
