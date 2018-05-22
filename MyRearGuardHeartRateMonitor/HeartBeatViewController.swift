//
//  HeartBeatViewController.swift
//  MyRearGuardHeartRateMonitor
//
//  Created by Pratistha Sthapit on 5/22/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import FirebaseDatabase
import CoreLocation


class HeartBeatViewController: UIViewController, CLLocationManagerDelegate {
    var db: DatabaseReference?
    var handle:DatabaseHandle?
    var data:String = ""
    var date = Date()
    var dateToday : String = ""
    var timeToday : String = ""
    let dateFormatter = DateFormatter()
    var lati = Double ()
    var longi = Double ()
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        data = _emailID
        print (data)
        locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            print (location.coordinate)
            lati = location.coordinate.latitude
            longi = location.coordinate.longitude
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.denied){
            showLocationDisabledPopUp()
        }
    }
    func showLocationDisabledPopUp(){
        let alertController = UIAlertController(title:"Location Access Disabled", message:"We need your location to reach you", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default){(action) in if let url = URL (string: UIApplicationOpenSettingsURLString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            }
     }
        alertController.addAction(openAction)
        
        self.present(alertController,animated: true, completion: nil)
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var ref:DatabaseReference!
    var _emailID = String()
    
    @IBAction func ReportIncident(_ sender: UIButton) {
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        dateToday = (dateFormatter.string(from: date))
        dateFormatter.dateFormat = "hh:mm"
        timeToday = (dateFormatter.string(from: date))
        
        if (_emailID != ""){
            self.ref?.child("incidents").child("incident").child("3").setValue(["attack type": "testing","date": dateToday,"medic" : "" , "patient": _emailID, "time": timeToday, "longitude":longi,"latitude":lati])
            print ("success")
            print (_emailID)
        }
        /*self.ref?.child("patients").child ("patient").child(String (index + 1)).setValue(["First Name": self.FirstName.text, "Last Name": self.LastName.text, "Gender":self.Gender.text, "Email":self.Email.text, "Age": (self.Age.text)])*/
    }
    @IBOutlet weak var Test: UILabel!
    
    /*
     @IBAction func Register(_ sender: UIButton) {
     if (FirstName.text != "" && LastName.text != "" && Age.text != "" && Gender.text != "" && Email.text != "" && NewPassword.text != "" && ConfirmPassword.text != "" && PhoneNumber.text != ""){
     if(NewPassword.text == ConfirmPassword.text){
     // self.ref.child("patients").child ("patient").child ("1").setValue(["first name": FirstName.text])
     
     ref?.child("patients").child ("patient").childByAutoId().setValue(["First Name": FirstName.text, "Last Name": LastName.text, "Gender":Gender.text, "Email":Email.text, "Age": Int(Age.text!)])
     }
     }
     }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
