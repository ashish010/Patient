
//
//  HKBloodType.swift
//  MyRearGuardHeartRateMonitor
//  reference taken from 2017 Razeware LLC within rights
//  Created by Ashish on 5/21/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//

import HealthKit

extension HKBloodType {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Unknown"
    case .aPositive: return "A+"
    case .aNegative: return "A-"
    case .bPositive: return "B+"
    case .bNegative: return "B-"
    case .abPositive: return "AB+"
    case .abNegative: return "AB-"
    case .oPositive: return "O+"
    case .oNegative: return "O-"
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
