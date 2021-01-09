//
//  AdManager.swift
//  Study
//
//  Created by Navjeeven Mann on 2020-09-06.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import GoogleMobileAds
class AdManager {
    static var sharedInstance = AdManager()
    
    func createAndLoadInterstitial() -> GADInterstitial {
        // Get and return a new interstitial ad
        let interstitial = GADInterstitial(adUnitID: )
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func createAndLoadBanner(_ banner: GADBannerView) -> GADBannerView {
        // Get and return a new banner
        banner.adUnitID = 
        banner.load(GADRequest())
        return banner
    }
}
