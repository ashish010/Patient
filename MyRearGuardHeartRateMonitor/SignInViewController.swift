//
//  SignInViewController.swift
//  MyRearGuardHeartRateMonitor
//
//  Created by Pratistha Sthapit on 5/23/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseDatabase

class SignInViewController: UIViewController, UITextFieldDelegate {
    var db: DatabaseReference?
    var handle:DatabaseHandle?
    var ref: DatabaseReference!
    var signIn: String?
    
    
    @IBOutlet weak var secret: UILabel!

    
 
    @IBOutlet weak var Username: UITextField!
    
    
    @IBOutlet weak var Password: UITextField!
    //@IBOutlet weak var RegisterButtonLabel: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue"){
            let PatientInf = segue.destination as! MasterViewController
            PatientInf._emailID = "\(Username.text!)"
        }
        
        
    
    }
    
    func SignInMonitor() -> Void
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
                               
                                
                                if(p == self.signIn){
                                    
                                    
                                    self.db?.child("monitors").child("monitor").child("\(String(key))").child("IsOn").setValue("1")
                                    
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
    /*func createFile()-> Void
    {
        // Save data to file
        let fileName = "config"
        var message = ""
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        message = "Populate the text file"
        //var readString = "" // Used to store the file contents
        do {
            
            //write to the file
            try message.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
             print("file created")
            
        } catch let error as NSError {
           print(error)
        }
        
    }*/
    
    @IBAction func LogIn(_ sender: UIButton) {
        if (Username.text != "" && Password.text != ""){
            
            Auth.auth().signIn(withEmail: Username.text!, password: Password.text!, completion: {(user, error) in
                if user != nil {
                    //self.createFile()
                   
                    
                    self.signIn = self.Username.text!
                    self.SignInMonitor()
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
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
    func checkIfFileisEmpty()-> Bool{
        var message = ""
        let fileName = "config"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        do{
            message = try String(contentsOf: fileURL)
        }catch let error as NSError{
            print (error)
        }
        
        if message != ""{
            return false
        }
        else{
            return true
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Username.delegate = self
        self.Password.delegate = self
        
       if (checkIfFileisEmpty() == true){
           print("User has logged out properly.")
        }
        else{
            
            print("user hasn't logged out properly.")
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        return (true)
    }
    @IBOutlet weak var signupbtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
