//
//  MainCoordinatorView.swift
//  Weather - MVVM
//
//  Created by Martin on 07.05.2021.
//

import SwiftUI

struct MainCoordinatorView: View {
    
    @ObservedObject var mainCoordinator: MainCoordinator<SearchViewModel>
    
    var body: some View {
        if mainCoordinator.showLoading {
            ProgressView("Loading data ...")
        } else {
            NavigationView {
                SearchView(viewModel: mainCoordinator.searchViewModel)
                    .navigation(item: $mainCoordinator.cityDetailViewModel) { viewModel in
                        CityDetailView(viewModel: viewModel)
                    }
                    .navigationTitle("Search")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView(mainCoordinator: MainCoordinator(apiKey: ""))
    }
}
