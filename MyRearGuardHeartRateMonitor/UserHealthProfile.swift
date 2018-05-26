//
//  UserHealthProfile.swift
//  MyRearGuardHeartRateMonitor
//  reference taken from 2017 Razeware LLC within rights
//  Created by Ashish on 5/21/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//
    
import HealthKit

class UserHealthProfile {
  
  var age: Int?
  var biologicalSex: HKBiologicalSex?
  var bloodType: HKBloodType?
  var heightInMeters: Double?
  var weightInKilograms: Double?
    
    
  
  var bodyMassIndex: Double? {
    
    guard let weightInKilograms = weightInKilograms,
      let heightInMeters = heightInMeters,
      heightInMeters > 0 else {
        return nil
    }
    
    
    return (weightInKilograms/(heightInMeters*heightInMeters))
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
