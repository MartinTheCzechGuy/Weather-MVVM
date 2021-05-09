//
//  CityDetailViewModelType.swift
//  Weather - MVVM
//
//  Created by Martin on 09.05.2021.
//

import Combine

protocol CityDetailViewModelType: ObservableObject {
    var city: String { get }
    var weatherDescription: String { get }
    var temperature: Double { get }
    var pressure: Double { get }
    var humidity: Double { get }
}
