//
//  LightBulbController.swift
//  HomeKitLightbulbController
//
//  Created by Marco Del Giudice on 05/04/2019.
//  Copyright © 2019 Marco Del Giudice. All rights reserved.
//

import Foundation
import HomeKit

public class LightBulbController  {
    var scenarioIsActive : Bool
    
    init(scenarioIsActive : Bool) {
        self.scenarioIsActive = scenarioIsActive
    }
    
    // MARK: public func
    
    //check if the lightbulb has rgb
    //how to use : the output is true if the input accessory has rgb functionality
    public func hasRgb (bulb: HMAccessory) -> Bool {
        let hue = pickHueCharacteristic(bulb: bulb)
        if hue != nil {
            return true
        }else{
            return false
        }
    }
    
    //check if the lightbulb has saturation
    //how to use : the output is true if the input accessory has saturation functionality
    public func hasSaturation (bulb: HMAccessory) -> Bool {
        let hue = pickSaturationCharacteristic(bulb: bulb)
        if hue != nil {
            return true
        }else{
            return false
        }
    }
    
    //check if the lightbulb is turned on
    //how to use : the output is true if the lightbulb is on, false viceversa
    public func isOn (bulb: HMAccessory) -> Bool {
        if findCharacteristic(bulb: bulb, characteristicType: HMCharacteristicTypePowerState)?.value as! Bool == true {
            return true
        }else {
            return false
        }
    }
    
    //stop all the animation
    //how to use :
    public func stopAllAnimation () {
        self.scenarioIsActive = false
    }
    
    //Run the colorAnimation
    //how to use : fromColor is the starting color, toColor is the ending color, bulb is the lightbulb
    public func colorAnimation (fromColor: Float, toColor: Float, bulb: HMAccessory) {
        bulbHueAnimation(fromColor: fromColor, toColor: toColor, moving: fromColor-0.5, hue: pickHueCharacteristic(bulb: bulb)!)
    }
    
    
    //Run the intensityAnimation
    //how to use : fromIntensity is the starting intensity, toIntensity is the ending intensity, bulb is the lightbulb
    public func intensityAnimation (fromIntensity: Int, toIntensity: Int, bulb: HMAccessory) {
        bulbIntensityAnimation(fromInensity: fromIntensity, toInensity: toIntensity, moving: fromIntensity-1, intensity: pickIntensityCharacteristic(bulb: bulb)!)
    }
    
    //change the lightbulb color
    //how to use : toColor is the color to assign, bulb is the lightbulb
    public func changeColor (toColor: Float, bulb: HMAccessory) {
        let hue = pickHueCharacteristic(bulb: bulb)
        hue?.writeValue(toColor, completionHandler: { error in
            if error != nil {
                print("Something went wrong when attempting to change the color.")
            }
        })
    }
    
    //change the lightbulb color
    //how to use : toIntensity is the intensity to assign, bulb is the lightbulb
    public func changeIntensity (toIntensity: Int, bulb: HMAccessory) {
        let intensity = pickIntensityCharacteristic(bulb: bulb)
        intensity?.writeValue(toIntensity, completionHandler: { error in
            if error != nil {
                print("Something went wrong when attempting to change the intensity.")
            }
        })
    }
    
    //change the lightbulb color
    //how to use : toSaturation is the saturation to assign, bulb is the lightbulb
    public func changeSaturation (toSaturation: Int, bulb: HMAccessory) {
        let saturation = pickSaturationCharacteristic(bulb: bulb)
        saturation?.writeValue(toSaturation, completionHandler: { error in
            if error != nil {
                print("Something went wrong when attempting to change the saturation.")
            }
        })
    }
    
    //switch the lightbulb state , if the lighbulb is turned on it turn off and viceversa
    //bulb is the lightbulb
    public func switchState (bulb:HMAccessory) {
        let state = pickPowerState(bulb: bulb)
        if state?.value as! Bool == true {
            changeState(state: state!, toValue: false)
        }else {
            changeState(state: state!, toValue: true)
        }
    }
    
    //turn on the lightbulb NB: IT DOESN'T CHECK IF THE LIGHTBULB IS ALREADY TUNED ON
    //utilizzo: bulb is the lightbulb
    public func turnOn (bulb:HMAccessory) {
        changeState(state: pickPowerState(bulb: bulb)!, toValue: true)
    }
    
    //turn off the lightbulb NB: IT DOESN'T CHECK IF THE LIGHTBULB IS ALREADY TUNED OFF
    //utilizzo: bulb is the lightbulb
    public func turnOff (bulb:HMAccessory) {
        changeState(state: pickPowerState(bulb: bulb)!, toValue: false)
    }
    

    
    // MARK: private func
    
    private func bulbIntensityAnimation (fromInensity: Int, toInensity: Int, moving: Int, intensity: HMCharacteristic) {
        
        if self.scenarioIsActive == false {
            //spengo animazinoe
            return
        }else {
            if moving == toInensity {
                //inverto animazione
                self.bulbIntensityAnimation(fromInensity: toInensity, toInensity: fromInensity,moving: toInensity, intensity: intensity)
            }else{
                //continuo animazione
                intensity.writeValue(moving, completionHandler: { error in
                    if error != nil {
                        print("Something went wrong when attempting to change the intensity.")
                    }else {
                        if fromInensity > toInensity {
                            self.bulbIntensityAnimation(fromInensity: fromInensity , toInensity: toInensity, moving: moving-1, intensity: intensity)
                        }else {
                            self.bulbIntensityAnimation(fromInensity: fromInensity , toInensity: toInensity, moving: moving+1, intensity: intensity)
                        }
                    }
                })
            }
        }
    }
    
    private func bulbHueAnimation (fromColor: Float, toColor: Float, moving: Float, hue: HMCharacteristic) {
        
        if self.scenarioIsActive == false {
            //spengo animazinoe
            return
        }else {
            if moving == toColor {
                //inverto animazione
                self.bulbHueAnimation(fromColor: toColor, toColor: fromColor,moving: toColor, hue: hue)
            }else{
                //continuo animazione
                hue.writeValue(moving, completionHandler: { error in
                    if error != nil {
                        print("Something went wrong when attempting to change the color.")
                    }else {
                        if fromColor > toColor {
                            self.bulbHueAnimation(fromColor: fromColor , toColor: toColor, moving: moving-0.5, hue: hue)
                        }else {
                            self.bulbHueAnimation(fromColor: fromColor , toColor: toColor, moving: moving+0.5, hue: hue)
                        }
                    }
                })
            }
        }
    }
    
    private func pickIntensityCharacteristic (bulb: HMAccessory) -> HMCharacteristic?{
        let intensity = findCharacteristic(bulb: bulb, characteristicType: HMCharacteristicTypeBrightness)
        return intensity
    }
    
    private func pickHueCharacteristic (bulb: HMAccessory) -> HMCharacteristic?{
        let hue = findCharacteristic(bulb: bulb, characteristicType: HMCharacteristicTypeHue)
        return hue
    }
    
    private func pickSaturationCharacteristic (bulb: HMAccessory) -> HMCharacteristic?{
        let saturation = findCharacteristic(bulb: bulb, characteristicType: HMCharacteristicTypeSaturation)
        return saturation
    }
    
    private func pickPowerState (bulb: HMAccessory) -> HMCharacteristic?{
        let state = findCharacteristic(bulb: bulb, characteristicType: HMCharacteristicTypePowerState)
        return state
    }
    
    private func changeState (state: HMCharacteristic, toValue: Bool) {
        state.writeValue(NSNumber(value: toValue)) { error in
            if error != nil {
                print("Something went wrong when attempting to update the service characteristic.")
            }
        }
    }
    
    private func findCharacteristic (bulb: HMAccessory, characteristicType: String) -> HMCharacteristic?{
        var characteristic : HMCharacteristic? = nil
        var service : HMService? = nil
        var index = 0
        while index < bulb.services.count && service != nil{
            if bulb.services[index].serviceType == HMServiceTypeLightbulb {
                service = bulb.services[index]
            }
            index += 1
        }
        if service != nil {
            index = 0
            while index < service!.characteristics.count && characteristic != nil {
                if service!.characteristics[index].characteristicType == characteristicType {
                    characteristic = service!.characteristics[index]
                }
                index += 1
            }
        }
        
    return characteristic
    }
    
}
