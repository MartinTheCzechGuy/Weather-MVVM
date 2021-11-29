import Combine
import XCTest
@testable import Weather___MVVM

final class CurrentWeatherRepositoryStub: CurrentWeatherRepositoryType {
    
    private let result: Result<CurrentWeather, WeatherError>
                            
    init(result: Result<CurrentWeather, WeatherError>) {
        self.result = result
    }
    
    func currentWeather(for city: String) -> AnyPublisher<Result<CurrentWeather, WeatherError>, Never> {
        Just(result).eraseToAnyPublisher()
    }
}

class SearchViewModelTests: XCTestCase {

    private var bag = Set<AnyCancellable>()
    
    func test_fetch_weather_success() {
        let weather = CurrentWeather(
            city: "random city",
            weather: .mist,
            description: "desc",
            temperature: 10,
            pressure: 20,
            humidity: 30
        )
        let repository = CurrentWeatherRepositoryStub(result: .success(weather))
        let sut = SearchViewModel(currentWeatherRepository: repository)
        
        let expectation = expectation(description: "Should have receive a value")
        
        sut.$results
            .dropFirst()
            .sink(
                receiveValue: { weatherArray in
                    XCTAssertEqual(weatherArray.count, 1)
                    XCTAssertEqual(weatherArray.first?.city, weather.city)
                    XCTAssertEqual(weatherArray.first?.weather, weather.weather)
                    XCTAssertEqual(weatherArray.first?.description, weather.description)
                    XCTAssertEqual(weatherArray.first?.temperature, weather.temperature)
                    XCTAssertEqual(weatherArray.first?.pressure, weather.pressure)
                    XCTAssertEqual(weatherArray.first?.humidity, weather.humidity)

                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.city = "city"
        
        waitForExpectations(timeout: 1)
    }

    func test_fetch_weather_failure() {
        let repository = CurrentWeatherRepositoryStub(result: .failure(.buildingRequestFailure))
        let sut = SearchViewModel(currentWeatherRepository: repository)
        
        let expectation = expectation(description: "Should have receive an error")
        
        sut.$showError
            .dropFirst()
            .sink(
                receiveValue: { isErrorShown in
                    guard isErrorShown else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.city = "city"
        
        waitForExpectations(timeout: 1)
    }
}
