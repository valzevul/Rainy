//
//  ViewController.swift
//  Rainy
//
//  Created by Vadim Drobinin on 13/10/14.
//  Copyright (c) 2014 Vadim Drobinin. All rights reserved.
//

import UIKit
import CoreLocation

struct Coordinates {
    var latitude = 0.0
    var longitude = 0.0
}

class ViewController: UIViewController, CLLocationManagerDelegate {

    private var coordinates : Coordinates = Coordinates()
    private var locationManager : CLLocationManager = CLLocationManager()
    private var geocoder : CLGeocoder = CLGeocoder()
    private var placemark : CLPlacemark = CLPlacemark()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() -> Void {
        
        coordinates = getCoordinates()
        let apiKey = getApiKey()
        let URL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)")
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(URL,
            completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Update UI with the weather
                    })
                    
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)
                    
                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Update UI with the weather
                        // Stop activity button
                    })
                    
                }
                
        })
        downloadTask.resume()
        
    }
    
    func getApiKey() -> String {
        return ""  // For test purposes only
    }
    
    func getCoordinates() -> Coordinates {
        let result = Coordinates(latitude: 35, longitude: 139) // For test purposes only
        return result
    }
    
}

