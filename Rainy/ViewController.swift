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

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rainProbabilityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var coordinates : Coordinates = Coordinates()
    private var locationManager : CLLocationManager = CLLocationManager()
    private var geocoder : CLGeocoder = CLGeocoder()
    private var placemark : CLPlacemark = CLPlacemark()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
                    println(weatherDictionary)
                    let currentWeather = Current(weatherDictionary: weatherDictionary)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Update UI with the weather
                        self.temperatureLabel.text = "\(Int(currentWeather.temperature!))"
                        self.locationLabel.text = "in \(currentWeather.location)"
                        self.rainProbabilityLabel.text = "\(currentWeather.rainProbability3h)"
                        self.weatherImage.image = currentWeather.icon
                        self.timeLabel.text = "At \(currentWeather.time!) it is"
                        self.windLabel.text = "\(currentWeather.windSpeed) m/s \(currentWeather.windDirection!)"
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
        // return coordinates
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError %@", error)
        var errorAlert : UIAlertView = UIAlertView(title: "Error", message: "Failed to get your location", delegate: nil, cancelButtonTitle: "OK")
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation : CLLocation = locations[0] as CLLocation
        if (!currentLocation.isEqual(nil)) {
            coordinates = Coordinates(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
        locationManager.stopUpdatingLocation()
    }

    
}

