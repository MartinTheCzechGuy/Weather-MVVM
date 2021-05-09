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
    
    // Private
    private let currentWeatherRepository: CurrentWeatherRepositoryType
    private unowned let coordinator: MainCoordinator<SearchViewModel>
    private var bag = Set<AnyCancellable>()

    init(
        currentWeatherRepository: CurrentWeatherRepositoryType,
        coordinator: MainCoordinator<SearchViewModel>
    ) {
        self.currentWeatherRepository = currentWeatherRepository
        self.coordinator = coordinator
        
        $city
            .compactMap { $0.count == .zero ? nil : $0 }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .background))
            .flatMap(currentWeatherRepository.currentWeather(for:))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {_ in },
                receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    
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
    
    func showDetail(for weather: CurrentWeather) {
        coordinator.showDetail(for: weather)
    }
}
