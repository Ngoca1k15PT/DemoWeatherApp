//
//  ViewController.swift
//  demoappweather
//
//  Created by Hoang Ngoc on 15/11/2023.
//

import WeatherKit
import RevenueCat
import UIKit
import RevenueCatUI

class WeatherViewController: UIViewController {
    
    private let primaryView = CurrentWeatherView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getLocation()
    }
    
    @objc
    private func didTapUpgrade() {
        let vc = PaywallViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func getLocation() {
        LocationManager.shared.getCurrentLocation { location in
            WeatherManager.shared.getWeather(for: location){ [weak self] in
                DispatchQueue.main.async {
                    guard let currentWeather = WeatherManager.shared.currentWeather else {return}
                    self?.createViewModels(currentWeather: currentWeather)
                }
            }
        }
    }
    
    private func createViewModels(currentWeather: CurrentWeather) {
        var viewModels: [WeatherViewModel] = [
            .current(viewModel: .init(model: currentWeather)),
            .hourly(viewModels: WeatherManager.shared.hourlyWeather.compactMap({ .init(model: $0)})),
        ]
        primaryView.configure(with: viewModels)
        
        IAPManager.shared.isSubscribed { [weak self] subscribed in
            if subscribed{
                viewModels.append(
                    .daily(viewModels: WeatherManager.shared.dailyWeather.compactMap({ .init(model: $0)}))
                )
                DispatchQueue.main.async {
                    self?.primaryView.configure(with: viewModels)
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "crown"),
                                                                        style: .done,
                                                                        target: self,
                                                                              action: #selector(self?.didTapUpgrade))
                }
            }
        }
            
    }

    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(primaryView)
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension WeatherViewController: PaywallViewControllerDelegate {
    func paywallViewController(_ controller: PaywallViewController, didFinishPurchasingWith customerInfo: CustomerInfo) {
        print("Purchased: \(customerInfo)")
        controller.dismiss(animated: true)
        guard let currentWeather = WeatherManager.shared.currentWeather else {return}
        createViewModels(currentWeather: currentWeather)
    }
    
    func paywallViewController(_ controller: PaywallViewController, didFinishRestoringWith customerInfo: CustomerInfo) {
        print("Restored: \(customerInfo)")
        controller.dismiss(animated: true)
    }
}
