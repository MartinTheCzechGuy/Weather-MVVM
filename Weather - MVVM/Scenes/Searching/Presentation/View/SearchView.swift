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
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Enter city name...", text: $viewModel.city)
            }
            .padding(10)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, opacity: 1)
                        ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            
            if (!viewModel.results.isEmpty) {
                HStack {
                    VStack { Divider().background(Color.black) }.padding(10)
                    Text("Results").foregroundColor(.black)
                    VStack { Divider().background(Color.black) }.padding(10)
                }
                .padding()
            }
            
            List(viewModel.results, id: \.self) { weather in
                Text(weather.city)
                    .onNavigation { viewModel.navigationClick.send(weather) }
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        }
        .padding()
        .alert(isPresented: $viewModel.showError) { () -> Alert in
            Alert(
                title: Text("The city name \(viewModel.city) not found. Please try a different search."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
