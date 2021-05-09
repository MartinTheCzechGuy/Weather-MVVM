//
//  CityDetailView.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import SwiftUI

struct CityDetailView: View {
    
    @ObservedObject var viewModel: CityDetailViewModel
    
    var body: some View {
        VStack {
            Text("Weather in \(viewModel.city) right now - \(viewModel.weatherDescription) \(viewModel.temperature < 15 ? "☀️" :  "☁️")")
            Text("🌡 Temperature - \(String(format: "%.1f", viewModel.temperature)) ℃")
            Text("Pressure - \(String(format: "%.1f", viewModel.pressure)) mb")
            Text("💧 Humidity - \(String(format: "%.1f", viewModel.humidity)) %")
        }
        .navigationTitle("Weather in \(viewModel.city)")
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(viewModel: CityDetailViewModel(
            city: "",
            weatherDescription: "Raining",
            temperature: 22,
            pressure: 22,
            humidity: 22
        )
        )
    }
}
