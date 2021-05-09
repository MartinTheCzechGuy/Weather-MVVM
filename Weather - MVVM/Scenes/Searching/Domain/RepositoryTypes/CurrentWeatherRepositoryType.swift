//
//  CurrentWeatherRepositoryType.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import Combine

protocol CurrentWeatherRepositoryType {
    func currentWeather(for city: String) -> AnyPublisher<Result<CurrentWeather, WeatherError>, Never>
}
