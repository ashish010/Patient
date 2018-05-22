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

class SignInViewController: UIViewController {
    var db: DatabaseReference?
    var handle:DatabaseHandle?
    var ref: DatabaseReference!
    
    
    
 
    @IBOutlet weak var Username: UITextField!
    
    
    @IBOutlet weak var Password: UITextField!
    //@IBOutlet weak var RegisterButtonLabel: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue2"){
            let PatientInf = segue.destination as! MasterViewController
            PatientInf.emailID = "\(Username.text!)"
        }
        
        
    
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
