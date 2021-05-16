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
        ZStack {
            viewModel.weatherCode.background.ignoresSafeArea()
            
            VStack(
                alignment: .center,
                spacing: 20
            ) {
                Image(systemName: viewModel.weatherCode.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                                
                VStack {
                    Text(viewModel.weatherDescription)
                    Text("🌡 Temperature - \(String(format: "%.1f", viewModel.temperature)) ℃")
                    Text("Pressure - \(String(format: "%.1f", viewModel.pressure)) mb")
                    Text("💧 Humidity - \(String(format: "%.1f", viewModel.humidity)) %")
                }
                .font(.title3)
            }
            .navigationTitle("Weather in \(viewModel.city)")
        }
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(
            viewModel: CityDetailViewModel(
                city: "",
                weatherCode: .clear,
                weatherDescription: "Raining",
                temperature: 22,
                pressure: 22,
                humidity: 22
            )
        )
    }
}
