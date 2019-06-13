//
//  ServiceExtension.swift
//  EfficientRats
//
//  Created by Marco Del Giudice on 07/04/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import Foundation
import HomeKit

extension HMAccessory {
    
    
    //check if the accessory is a lightbulb
    //how to use : if HMAccessory.isLightbulb == true -> is a lightbulb.
    public func isLightbulb () -> Bool {
        return self.checkServiceType(serviceType: HMServiceTypeLightbulb)
    }
    
    
    private func checkServiceType (serviceType : String) -> Bool{
        var ret = false
        var index = 0
        while index < self.services.count {
            if self.services[index].serviceType == serviceType {
                ret = true
            }
            index += 1
        }
        return ret
    }
    
}
