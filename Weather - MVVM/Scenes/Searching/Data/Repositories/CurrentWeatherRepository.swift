//
//  CurrentWeatherRepository.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import Foundation
import Combine

final class CurrentWeatherRepository: CurrentWeatherRepositoryType {
    
    struct OpenWeatherAPI {
      static let scheme = "https"
      static let host = "api.openweathermap.org"
      static let path = "/data/2.5"
    }
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func currentWeather(for city: String) -> AnyPublisher<Result<CurrentWeather, WeatherError>, Never> {
        guard let url = currentWeatherComponents(for: city).url else {
            return Just(.failure(.buildingRequestFailure))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map { $0.data }
            .mapError { error -> WeatherError in
                if error.errorCode == 404 {
                    return WeatherError.cityNotFound
                }
                
                return WeatherError.unknownError
            }
            .flatMap { data -> AnyPublisher<CurrentWeatherDTO, WeatherError> in
                let decoder = JSONDecoder()
                
                guard let weather = try? decoder.decode(CurrentWeatherDTO.self, from: data) else {
                    return Fail(error: WeatherError.decodingError).eraseToAnyPublisher()
                }
                
                return Just(weather)
                    .setFailureType(to: WeatherError.self)
                    .eraseToAnyPublisher()
            }
            .map { dto in
                var weatherCode: WeatherCode
                switch dto.weather.first!.id {
                case 200..<300: weatherCode = .thunderstorm
                case 300..<400: weatherCode = .drizzle
                case 500..<600: weatherCode = .rain
                case 600..<700: weatherCode = .snow
                case 700..<800: weatherCode = .mist
                case 801..<900: weatherCode = .clouds
                default:
                    weatherCode = .clear
                }
                
                return CurrentWeather(
                    city: dto.name,
                    weather: weatherCode,
                    description: dto.weather.first?.description ?? "No weather description.",
                    temperature: dto.main.temp,
                    pressure: dto.main.pressure,
                    humidity: dto.main.humidity
                )
            }
            .mapToResult()
            .eraseToAnyPublisher()
    }
    
    private func currentWeatherComponents(for city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/weather"
        
        components.queryItems = [
          URLQueryItem(name: "q", value: city),
          URLQueryItem(name: "mode", value: "json"),
          URLQueryItem(name: "units", value: "metric"),
          URLQueryItem(name: "APPID", value: apiKey)
        ]
        
        return components
    }
}

private struct CurrentWeatherDTO: Decodable {
    let name: String
    let weather: [WeatherDescriptionDTO]
    let main: WeatherDataDTO
    
    struct WeatherDescriptionDTO: Decodable {
        let id: Int
        let main: String
        let description: String
    }
    
    struct WeatherDataDTO: Decodable {
        let temp: Double
        let pressure: Double
        let humidity: Double
    }
}
