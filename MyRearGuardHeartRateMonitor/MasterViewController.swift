
//
//  MasterViewController.swift
//  MyRearGuardHeartRateMonitor
//  reference taken from 2017 Razeware LLC within rights
//  Created by Ashish on 5/21/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase
import HealthKit

class MasterViewController: UITableViewController {
    var db: DatabaseReference?
    var handle:DatabaseHandle?
    var signoff: String?
    var email = String()
    var _emailID = String()
    
    private let authorizeHealthKitSection = 2
    private let logoutSection = 3
   
    //static let heartRate: HKQuantityTypeIdentifier
    override func viewDidLoad() {
        signoff = _emailID
        print("Master Loaded")
        
    }
    
    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
            print(self._emailID)
            
        }
        
    }
    var emailID = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueheart"){
            let PatientInfo = segue.destination as! HeartBeatViewController
            PatientInfo.emailIDfromMaster = "\(_emailID)"
            
            
        }
        if (segue.identifier == "profileSegue") {
            let PatientInfo = segue.destination as! ProfileViewController
            PatientInfo.emailfromMaster = "\(_emailID)"
            
        }
        
        
    }
    
    func signOff() -> Void
    {
        db = Database.database().reference()
        let ref = db?.child("monitors").child("monitor")
        
        ref?.observe(.value, with: { (snapshot: DataSnapshot!) in
            self.handle = ref?.observe(.childAdded, with: { (snapshot) in
                if let key = snapshot.key as? String {
                    self.handle = self.db?.child("monitors/monitor").child(key).observe(.childAdded, with: { (snapshot) in
                        if let data = snapshot.key as? String {
                            if(data == "Email"){
                                let p = snapshot.value as? String
                                if(p == self.signoff){
                                    self.db?.child("monitors").child("monitor").child("\(String(key))").child("IsOn").setValue("0")
                                    
                                    ref?.removeAllObservers()
                                    
                                }
                            }
                        }
                        ref?.removeAllObservers()
                    })
                }
            })
        })
    }
   /* func EmptyFile(){
        
        let message = ""
        let fileName = "config"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        do {
            
            //write to the file
            try message.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("file made empty. logged out")
            
        } catch let error as NSError {
            print(error)
        }
    }*/
    
    
    private func LogOut(){
        try! Auth.auth().signOut()
        //EmptyFile()
        signoff = _emailID
        signOff()
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == authorizeHealthKitSection {
            authorizeHealthKit()
            
        }
        if(indexPath.section == logoutSection){
            LogOut()
        }
    }
    
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
