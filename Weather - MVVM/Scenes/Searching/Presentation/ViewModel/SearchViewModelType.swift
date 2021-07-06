//
//  SearchViewModelType.swift
//  Weather - MVVM
//
//  Created by Martin on 09.05.2021.
//

import Combine

protocol SearchViewModelType: ObservableObject {
    
    // Output - communication from view model to view. VM State
    var city: String { get set }
    var results: [CurrentWeather] { get }
    var showError: Bool { get set }
    
    // Input - communication from view to view model
    var hideErrorClick: PassthroughSubject<Void, Never> { get }
    var navigationClick: PassthroughSubject<CurrentWeather, Never> { get }
    
    // Action - communication from view model to coordinator
    var navigateToDetail: AnyPublisher<CurrentWeather, Never> { get }
    var showLoading: AnyPublisher<Bool, Never> { get }
}
