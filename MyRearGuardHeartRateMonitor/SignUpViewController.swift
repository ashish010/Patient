//
//  ViewController.swift
//  MyRearGuard
//
//  Created by Pratistha Sthapit on 5/11/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseDatabase


class SignUpViewController: UIViewController {
    var db: DatabaseReference?
    var handle:DatabaseHandle?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var ref: DatabaseReference!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    //@IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    //@IBOutlet weak var Password: UITextField!
    @IBOutlet weak var RegisterButtonLabel: UIButton!
    
    
    
        
    
    
    
   
    func addPatient()-> Void{
        db = Database.database().reference()
        let ref = db?.child("patients").child("patient").queryLimited(toLast: 1)
        self.handle = ref?.observe(.childAdded, with: {(snapshot) in
            if let val = snapshot.key as? String {
                let patient = Patient(indexNumber: Int(val)!)
                patient.indexNumber = patient.indexNumber + 1
                
                self.db?.child("patients").child("patient").child("\(String(patient.indexNumber))").child("Age").setValue(self.Age.text)
                self.db?.child("patients").child("patient").child("\(String(patient.indexNumber))").child("First Name").setValue(self.FirstName.text)
                self.db?.child("patients").child("patient").child("\(String(patient.indexNumber))").child("Last Name").setValue(self.LastName.text)
                self.db?.child("patients").child("patient").child("\(String(patient.indexNumber))").child("Gender").setValue(self.Gender.text)
                self.db?.child("patients").child("patient").child("\(String(patient.indexNumber))").child("Email").setValue(self.Email.text)
                
                
                
                ref?.removeAllObservers()
            }
        })
    }
    func addMonitor(_activeEmail: String, _isOn: String) -> Void {
        db = Database.database().reference()
        let ref = db?.child("monitors").child("monitor").queryLimited(toLast: 1)
        self.handle = ref?.observe(.childAdded, with: { (snapshot) in
            if let val = snapshot.key as? String{
                let monitorActive = Patient(indexNumber: Int(val)!)
                monitorActive.indexNumber = monitorActive.indexNumber+1
                
             
                self.db?.child("monitors").child("monitor").child("\(String(monitorActive.indexNumber))").child("Email").setValue(_activeEmail)
                
                self.db?.child("monitors").child("monitor").child("\(String(monitorActive.indexNumber))").child("IsOn").setValue(_isOn)
                ref?.removeAllObservers()
            }
            
        })
        
    }
    

    @IBAction func Register(_ sender: UIButton) {
        
        if (FirstName.text != "" && LastName.text != "" && Age.text != "" && Gender.text != "" && Email.text != "" && NewPassword.text != "" && ConfirmPassword.text != "" && PhoneNumber.text != ""){
            Auth.auth().createUser(withEmail: Email.text!, password: NewPassword.text!, completion: {(user, error) in
                if user != nil {
                    if(self.NewPassword.text == self.ConfirmPassword.text){
                        
                        self.addPatient()
                        self.addMonitor(_activeEmail: self.Email.text!,_isOn: "0")
                        self.performSegue(withIdentifier: "segueSignUp", sender: self)
                        
                    }
                }
                else{
                    if let Error = error?.localizedDescription{
                        print (Error)
                    }else{
                        
                    }
                }
            })
            
        }
    }
}


    
    


