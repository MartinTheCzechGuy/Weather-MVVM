//
//  WeatherError.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

enum WeatherError: Error {
    case cityNotFound
    case unknownError
    case buildingRequestFailure
    case decodingError
}
