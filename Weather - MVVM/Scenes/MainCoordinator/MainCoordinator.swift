//
//  MainCoordinator.swift
//  Weather - MVVM
//
//  Created by Martin on 07.05.2021.
//

import Foundation

class MainCoordinator<SearchVM>: ObservableObject where SearchVM: SearchViewModelType {
    
    @Published var searchViewModel: SearchVM!
    @Published var cityDetailViewModel: CityDetailViewModel?
    
    init(apiKey: String) {
        self.searchViewModel = SearchViewModel(
            currentWeatherRepository: CurrentWeatherRepository(apiKey: apiKey),
            coordinator: self as! MainCoordinator<SearchViewModel>
        ) as? SearchVM
    }
    
    func showDetail(for weather: CurrentWeather) {
        self.cityDetailViewModel = .init(
            city: weather.city,
            weatherDescription: weather.description,
            temperature: weather.temperature,
            pressure: weather.pressure,
            humidity: weather.humidity
        )
    }
}
