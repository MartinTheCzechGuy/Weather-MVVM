//
//  SearchView.swift
//  Weather - MVVM
//
//  Created by Martin on 08.05.2021.
//

import SwiftUI

struct SearchView<ViewModel>: View where ViewModel: SearchViewModelType {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TextField("Enter city name...", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List(viewModel.results, id: \.self) { weather in
                Text(weather.city)
                    .onNavigation { viewModel.showDetail(for: weather) }
            }
        }
        .alert(isPresented: $viewModel.showError) { () -> Alert in
            Alert(
                title: Text("The city name \(viewModel.city) not found. Please try a different search."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
