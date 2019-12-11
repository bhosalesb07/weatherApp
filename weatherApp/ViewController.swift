//
//  ViewController.swift
//  weather
//
//  Created by Mac on 19/12/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=463796d3d2ccc5cae8fea4ae8916f283

class ViewController: UIViewController , CLLocationManagerDelegate, UITextFieldDelegate{
    
    var latitude:CGFloat?
    var longitude:CGFloat?
    var shtemp = String()
    var shhum = String()
    var shdsc = String()
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var lbltemp: UILabel!
    
    @IBOutlet weak var lblhum: UILabel!
    
    @IBOutlet weak var lbldes: UILabel!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var txtfldhum: UITextField!
    
    @IBOutlet weak var txtddscp: UITextField!
    
    @IBOutlet weak var txtfldtemp: UITextField!
    
    @IBOutlet weak var txttemp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocation.delegate = self
        let urlstr = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=463796d3d2ccc5cae8fea4ae8916f283"
        parseJson(urlString: urlstr)
        // Do any additional setup after loading the view, typically from a nib.
        startDetectingLocation()
    }
    
    func startDetectingLocation()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let geo = CLGeocoder()
        geo.geocodeAddressString(textField.text!) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            let coordinate = location?.coordinate
            self.latitude = CGFloat((coordinate?.latitude)!)
            self.longitude = CGFloat((coordinate?.longitude)!)
            print(self.latitude!)
            print(self.longitude!)
            let urlstr =
            "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude!)&lon=\(self.longitude!)&appid=463796d3d2ccc5cae8fea4ae8916f283"
            print(urlstr)
            self.parseJson(urlString: urlstr)
            
        }
        
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        latitude = CGFloat(currentLocation.coordinate.latitude)
        longitude = CGFloat(currentLocation.coordinate.longitude)
        
        print("latitude =\(latitude) and longitude =\(longitude)")
    }
    
    
    @IBAction func btnShowLocTapped(_ sender: UIButton) {
        // let urlstr = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=463796d3d2ccc5cae8fea4ae8916f283"
        // parseJson(urlString: urlstr)
        
        showfunc()
        
    }
    
    func showfunc()
    {
        print(shhum)
        print(shdsc)
        print(shtemp)
        txtfldhum.text = shhum
        txtddscp.text = shdsc
        txtddscp.backgroundColor = .red
        txttemp.text = String(shtemp)
        /*self.txtfldhum.text = shhum //humidity1
         self.txtddscp.text = shdsc//DecDic
         self.txtfldtemp.text = shtemp//temp1*/
    }
    func parseJson(urlString: String)
    {
        enum jsonError: String,Error
        {
            case responseError = "Response not found"
            case dateError = "Date not found"
            case ConversionError = "Conversion failed"
        }
        
        guard let endPoint = URL(string: urlString)
            else
        {
            print("End point not found")
            return
        }
        
        URLSession.shared.dataTask(with: endPoint) { (data, response, error) in
            do
            {
                guard let response1 = response
                    else
                {
                    throw jsonError.responseError
                }
                print(response1)
                
                guard let data = data
                    else
                {
                    throw jsonError.dateError
                }
                
                let firstArray = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                print("firsrArray = \(firstArray)")
                
                let mainDic = firstArray["main"] as! [String:Any]
                
                print("main =\(mainDic["temp"] as! Double)")
                
                let temp = mainDic["temp"] as! Double
                let temp1:String = String(format: "%f", temp)
                // print(" temp1 =\(temp1)")
                //self.lbltemp.text = temp1
                self.shtemp  = temp1
                let humidity = mainDic["humidity"] as! Double
                let humidity1:String = String(format: "%f", humidity)
                // self.lblhum.text = humidity1
                self.shhum = humidity1
                let weatherDic:[[String:Any]] = firstArray["weather"] as! [[String:Any]]
                //print("weatheDic = \(weatherDic)")
                for item in weatherDic
                {
                    let DecDic : String = (item["description"] as?String)!
                    //print("DecDic = \(DecDic)")
                    //self.lbldes.text = DecDic
                    self.shdsc = DecDic
                }
            }
            catch let error as jsonError
            {
                print(error.rawValue)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            }.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

