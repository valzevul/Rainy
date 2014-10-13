//
//  Current.swift
//  Rainy
//
//  Created by Vadim Drobinin on 13/10/14.
//  Copyright (c) 2014 Vadim Drobinin. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var rainProbability3h: Double
    var location: String
    var description: String?
    var windSpeed: Double
    var windDirection: String?

    var temperature: Double?
    var time: String?
    var icon: UIImage?
    
    init(weatherDictionary: NSDictionary) {
        let rainDict = weatherDictionary["rain"] as NSDictionary
        let currentWeatherDict = weatherDictionary["main"] as NSDictionary
        let currentWindDict = weatherDictionary["wind"] as NSDictionary
        let weatherDescription = weatherDictionary["weather"] as NSArray
        println(currentWindDict)
        
        rainProbability3h = rainDict["3h"] as Double
        description = weatherDescription[0]["main"] as? String
        var name = weatherDescription[0]["icon"] as String
        location = weatherDictionary["name"] as String
        windSpeed = currentWindDict["speed"] as Double
        
        temperature = celciusFromKelvin(currentWeatherDict["temp"] as Double)
        time = dateStringFromUnixTime(weatherDictionary["dt"] as Int)
        icon = weatherIconFromString(name)
        windDirection = windDirectionFromDegree(currentWindDict["deg"] as Double)
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func celciusFromFahrenheit(temperatureInFahrenheit: Int) -> Int {
        return (temperatureInFahrenheit - 32) * 5/9
    }
    
    func celciusFromKelvin(temperatureInKelvin: Double) -> Double {
        return temperatureInKelvin - 273.15
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var iconImage = UIImage(named: stringIcon)
        return iconImage
    }
    
    func windDirectionFromDegree(deg: Double) -> String {
        // Based on http://www.climate.umn.edu/snow_fence/components/winddirectionanddegreeswithouttable3.htm
        
        if (deg > 326.25) || (deg <= 56.25) { // NNW, N, NNE, NE
            return "↑"
        } else if (deg > 56.25) && (deg <= 146.25) { // ENE, E, ESE, SE
            return "→"
        } else if (deg > 146.25) && (deg <= 236.25) { // SSE, S, SSW, SW
            return "↓"
        } else if (deg > 236.25) && (deg <= 326.25) { // WSW, W, WNW, NW
            return "←"
        } else {
            return "x"
        }
    }
}