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

    var temperature: Double?
    var time: String?
    var icon: UIImage?
    
    init(weatherDictionary: NSDictionary) {
        let rainDict = weatherDictionary["rain"] as NSDictionary
        let currentWeatherDict = weatherDictionary["main"] as NSDictionary
        let weatherDescription = weatherDictionary["weather"] as NSArray
        
        rainProbability3h = rainDict["3h"] as Double
        description = weatherDescription[0]["main"] as? String
        var name = weatherDescription[0]["icon"] as String
        location = weatherDictionary["name"] as String
        
        temperature = celciusFromKelvin(currentWeatherDict["temp"] as Double)
        time = dateStringFromUnixTime(weatherDictionary["dt"] as Int)
        icon = weatherIconFromString(name)
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
}