//
//  SettingsViewViewModel.swift
//  demoappweather
//
//  Created by Hoang Ngoc on 15/11/2023.
//

import Foundation

struct SettingsViewViewModel {
    let options: [SettingOption]
}

enum SettingOption: CaseIterable {
    case upgrade
    case privacyPolicy
    case terms
    case contact
    case getHelp
    case rateApp
    
    var title: String {
        switch self{
        case .upgrade:
            return "Upgrade to pro"
        case .privacyPolicy:
            return "Privacy Policy"
        case .terms:
            return "Terms of use"
        case .contact:
            return "Contact Us"
        case .getHelp:
            return "Get Help"
        case .rateApp:
            return "Rate App"
        }
    }
}
