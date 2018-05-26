//
//  HeartBeatViewController.swift
//  MyRearGuardHeartRateMonitor
//
//  Created by Pratistha Sthapit on 5/22/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SwiftKeychainWrapper
import FirebaseDatabase
import CoreLocation
import HealthKit

/*protocol HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample])
}*/
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
    var emailIDfromMaster = String()
    let locationManager = CLLocationManager()
    
    var datasource: [String] = ["60","80"]
    
    @IBOutlet weak var HeartRateLabel: UILabel!
    var heartRateQuery: HKQuery?
    
   /* let heartRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let health: HKHealthStore = HKHealthStore()
    let heartRateUnit: HKUnit = HKUnit(from: "count/min")
   */
   
    /*var anchor: HKQueryAnchor?
    var heartRateDelegate: HeartRateDelegate?
    
    var heartRateQuery: HKQuery?
    var heartRateSamples: [HKQuantitySample] = [HKQuantitySample]()*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backfromheartbeatSegue"){
            let PatientInfo = segue.destination as! MasterViewController
            PatientInfo._emailID = "\(data)"
            
        }
        
    }
    func generateHeartBeat() -> Int{
        let random: Int = Int(arc4random_uniform(66) + 35);
         return (random)
    }
    func classifyHeartAttack() -> String {
        
        var heartBeat = generateHeartBeat()
        HeartRateLabel.text = "\(heartBeat) beats/min"
        if (heartBeat < 50 && heartBeat > 40) {
            return "Bradycardia"
            
        }else if (heartBeat > 90){
            return "Tachycardia"
        }
        else if (heartBeat < 40){
            return "Heart blocks"
        }
        else{
            return "-"
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
    
    
    
    
    @IBAction func ReportIncident(_ sender: UIButton) {
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        dateToday = (dateFormatter.string(from: date))
        dateFormatter.dateFormat = "hh:mm"
        timeToday = (dateFormatter.string(from: date))
        
        addIncident()
        ////let query = self.createStreamingQuery()
        ////self.health.execute(query)
    }
    func addIncident()-> Void{
        var testingHeartAttack = classifyHeartAttack()
        db = Database.database().reference()
        let ref = db?.child("incidents").child("incident").queryLimited(toLast: 1)
        self.handle = ref?.observe(.childAdded, with: {(snapshot) in
            if let val = snapshot.key as? String {
                let incident = Patient(indexNumber: Int(val)!)
                incident.indexNumber = incident.indexNumber + 1
                
                self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("attack type").setValue(testingHeartAttack)
                self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("date").setValue(self.dateToday)
                 self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("medic").setValue("")
                 self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("patient").setValue(self.emailIDfromMaster)
                 self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("time").setValue(self.timeToday)
                 self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("longitude").setValue(String(self.longi))
                 self.db?.child("incidents").child("incident").child("\(String(incident.indexNumber))").child("latitude").setValue(String(self.lati))
       
                
                
                ref?.removeAllObservers()
            }
            ref?.removeAllObservers()
        })
    }
    func retrieveHeartRateData(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database.database().reference()
        
        data = emailIDfromMaster
        
        print("HB Email from Master")
        print (data)
        
        locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            
        }
        
        self.retrieveHeartRateData()
    }
    
    
 
}
    




