//
//  SearchViewModelType.swift
//  Weather - MVVM
//
//  Created by Martin on 09.05.2021.
//

import Combine

protocol SearchViewModelType: ObservableObject {
    
    var hideErrorClick: PassthroughSubject<Void, Never> { get }
    var city: String { get set }
    var results: [CurrentWeather] { get }
    var showError: Bool { get set }
 
    func showDetail(for weather: CurrentWeather) -> Void
}
