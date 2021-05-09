//
//  Publisher+mapToResult.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import Combine

extension Publisher {
    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map(Result.success)
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}
