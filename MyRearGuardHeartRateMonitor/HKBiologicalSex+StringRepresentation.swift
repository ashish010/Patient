
//
//  HKBiologicalSex.swift
//  MyRearGuardHeartRateMonitor
//  reference taken from 2017 Razeware LLC within rights
//  Created by Ashish on 5/21/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//
import HealthKit

extension HKBiologicalSex {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Unknown"
    case .female: return "Female"
    case .male: return "Male"
    case .other: return "Other"
    }
  }
}
