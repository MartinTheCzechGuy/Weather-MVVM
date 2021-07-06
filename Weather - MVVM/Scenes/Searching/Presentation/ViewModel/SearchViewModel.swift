//
//  SearchViewModel.swift
//  Weather - MVVM
//
//  Created by Martin on 07.05.2021.
//

import Combine
import Foundation

final class SearchViewModel: SearchViewModelType {
    
    // Input
    let navigationClick = PassthroughSubject<CurrentWeather, Never>()
    let hideErrorClick = PassthroughSubject<Void, Never>()
    
    // Output
    @Published var city = "" {
        didSet {
            if city.count > 20 && oldValue.count <= 20 {
                city = oldValue
            }
        }
    }
    @Published var results: [CurrentWeather] = []
    @Published var showError = false
    
    // Action
    let navigateToDetail: AnyPublisher<CurrentWeather, Never>
    let showLoading: AnyPublisher<Bool, Never>
    
    // Private
    private let showLoadingSubject = PassthroughSubject<Bool, Never>()
    private let currentWeatherRepository: CurrentWeatherRepositoryType
    private var bag = Set<AnyCancellable>()

    init(currentWeatherRepository: CurrentWeatherRepositoryType) {
        self.currentWeatherRepository = currentWeatherRepository
        self.navigateToDetail = navigationClick.eraseToAnyPublisher()
        self.showLoading = showLoadingSubject.eraseToAnyPublisher()
        
        $city
            .compactMap { $0.count == .zero ? nil : $0 }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .flatMap { [weak self] city -> AnyPublisher<Result<CurrentWeather, WeatherError>, Never> in
                guard let self = self else {
                    return Just<Result<CurrentWeather, WeatherError>>(.failure(.unknownError)).eraseToAnyPublisher()
                }
                
                self.showLoadingSubject.send(true)

                return self.currentWeatherRepository.currentWeather(for: city) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {_ in },
                receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    
                    self.showLoadingSubject.send(false)
                                        
                    switch result {
                    case .success(let currentWeater):
                        self.results = [currentWeater]
                    case .failure(_):
                        self.showError = true
                    }
                }
            )
            .store(in: &bag)
        
        hideErrorClick
            .map { _ in false }
            .assign(to: \.showError, on: self)
            .store(in: &bag)        
    }
}
