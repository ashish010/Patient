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
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let PatientInf = segue.destination as! MasterViewController
        PatientInf.emailID = "\(Username.text!)"
        
    }*/
    /*@IBAction func LogIn(_ sender: UIButton) {
        if (Username.text != "" && Password.text != ""){
            Auth.auth().signIn(withEmail: Username.text!, password: Password.text!, completion: {(user, error) in
                if user != nil {
                    
                    self.performSegue(withIdentifier: "segue2", sender: self)
                }
                else{
                    if let Error = error?.localizedDescription{
                        print (Error)
                    }else{
                        
                    }
                }
            })
        }
        
    }*/
    
    /* func addActive()-> Void
     {
     db = Database.database().reference()
     let ref = db?.child("actives").child("active").queryLimited(toLast: 1)
     self.handle = ref?.observe(.childAdded, with: { (snapshot) in
     if let val = snapshot.key as? String{
     let medic = Medic(indexNumber: Int(val)!)
     medic.indexNumber = medic.indexNumber+1
     self.db?.child("actives").child("active").child("\(String(medic.indexNumber))").child("email").setValue(self.email.text)
     self.db?.child("actives").child("active").child("\(String(medic.indexNumber))").child("working").setValue(false)
     ref?.removeAllObservers()
     
     
     ///////
     self.handle = ref?.observe(DataEventType.value, with: { (snapshot) in
     let val = snapshot.value as? [String : AnyObject] ?? [:]
     var piid : Int?
     if ((val ["patients"]) != nil){
     print (val["patients"]!["patient"])
     }
     
     })
     }
     })
     }*/
    

    @IBAction func Register(_ sender: UIButton) {
        
        if (FirstName.text != "" && LastName.text != "" && Age.text != "" && Gender.text != "" && Email.text != "" && NewPassword.text != "" && ConfirmPassword.text != "" && PhoneNumber.text != ""){
            Auth.auth().createUser(withEmail: Email.text!, password: NewPassword.text!, completion: {(user, error) in
                if user != nil {
                    if(self.NewPassword.text == self.ConfirmPassword.text){
                        
                        let user = Auth.auth().currentUser
                        self.handle = self.ref?.child("patients").child("patient").child((user?.uid)!).observe(.childAdded, with: { (snapshot) in
                            
                            if let child = snapshot.value as? String{
                                
                                
                                
                                
                            }
                        })
                        var index: Int = 3
                        self.ref?.child("patients").child ("patient").child(String (index + 1)).setValue(["First Name": self.FirstName.text, "Last Name": self.LastName.text, "Gender":self.Gender.text, "Email":self.Email.text, "Age": (self.Age.text)])
                        self.performSegue(withIdentifier: "segue", sender: self)
                        
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
    /*
     {
     let email = self.Username.text
     let password = self.Password.text
     
     let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
     
     if (self.Username.text != nil && self.Password.text != nil){
     Auth.auth().createUser(withEmail : email!, password : password!, completion :{
     (user, error) in
     
     if(error == nil){
     let uid = Auth.auth()
     
     self.userID = user?.uid
     
     KeychainWrapper.standard.set(self.userID, forKey: "uid")
     
     //self.performSegue(withIdentifier: "MainView", sender: nil)
     
     }
     
     else{
     
     print("error xxd")
     
     }
     
     })
     
     }
     }*/
    
    


