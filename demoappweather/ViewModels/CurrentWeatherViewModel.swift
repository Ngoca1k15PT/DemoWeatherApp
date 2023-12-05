//
//  CurrentWeatherViewModel.swift
//  demoappweather
//
//  Created by Hoang Ngoc on 16/11/2023.
//

import Foundation

enum WeatherViewModel {
    case current(viewModel: CurrentWeatherCollectionViewCellViewModel)
    case hourly(viewModels: [HourlyWeatherCollectionViewCellViewModel])
    case daily(viewModels: [DailyWeatherCollectionViewCellViewModel])
}
