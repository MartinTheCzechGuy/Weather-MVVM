//
//  MainCoordinator.swift
//  Weather - MVVM
//
//  Created by Martin on 07.05.2021.
//

import Combine

class MainCoordinator<SearchVM>: ObservableObject where SearchVM: SearchViewModelType {
    
    @Published var searchViewModel: SearchVM
    @Published var cityDetailViewModel: CityDetailViewModel?
    
    private var bag = Set<AnyCancellable>()
    
    init(apiKey: String) {
        self.searchViewModel = (SearchViewModel(
            currentWeatherRepository: CurrentWeatherRepository(apiKey: apiKey)
        ) as? SearchVM)!
        
        setupBindings()
    }
    
    private func setupBindings() {
        searchViewModel.navigateToDetail
            .sink(receiveValue: { [weak self] weather in
                guard let self = self else { return }
                
                self.cityDetailViewModel = .init(
                    city: weather.city,
                    weatherCode: weather.weather,
                    weatherDescription: weather.description,
                    temperature: weather.temperature,
                    pressure: weather.pressure,
                    humidity: weather.humidity
                )
            })
            .store(in: &bag)
    }
}
