//
//  AttributionNetwork.swift
//  PurchasesCoreSwift
//
//  Created by César de la Vega on 6/18/21.
//  Copyright © 2021 Purchases. All rights reserved.
//

import Foundation

enum AttributionNetwork: Int {
    /**
     Apple's search ads
     */
    case RCAttributionNetworkAppleSearchAds = 0,
        /**
         Adjust https://www.adjust.com/
         */
         RCAttributionNetworkAdjust,
        /**
         AppsFlyer https://www.appsflyer.com/
         */
         RCAttributionNetworkAppsFlyer,
        /**
         Branch https://www.branch.io/
         */
         RCAttributionNetworkBranch,
        /**
         Tenjin https://www.tenjin.io/
         */
         RCAttributionNetworkTenjin,
        /**
         Facebook https://developers.facebook.com/
         */
         RCAttributionNetworkFacebook,
        /**
        mParticle https://www.mparticle.com/
        */
         RCAttributionNetworkMParticle
};
