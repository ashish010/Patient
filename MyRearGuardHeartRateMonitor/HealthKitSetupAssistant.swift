//
//  HealthKitSetupAssistant.swift
//  MyRearGuardHeartRateMonitor
//  reference taken from 2017 Razeware LLC within rights
//  Created by Ashish on 5/21/18.
//  Copyright © 2018 Ashish Khadka. All rights reserved.
//


import HealthKit

/*protocol HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample])
}*/
class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
   /* var anchor: HKQueryAnchor?
    var heartRateDelegate: HeartRateDelegate?
    var heartRateQuery: HKQuery?
    var heartRateSamples: [HKQuantitySample] = [HKQuantitySample]()*/
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        heartRate,
                                                        HKObjectType.workoutType()]
        
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       bloodType,
                                                       biologicalSex,
                                                       bodyMassIndex,
                                                       height,
                                                       bodyMass, heartRate,
                                                       HKObjectType.workoutType()]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
                                                
        }
       
        
    }
    /*
    func createHeartRateStreamingQuery(_ startDate: Date) -> HKQuery? {
        
        guard let heartRateType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate)else{
            return nil
            
        }
        let datePredicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictEndDate)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: compoundPredicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) in
            guard let newAnchor = newAnchor,
                let sampleObjects = sampleObjects else{
                    return
            }
            self.anchor = newAnchor
            self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
            heartRateQuery.updateHandler = {(query, sampleObjects,deletedObjects, newAnchor, error) -> Void in
                guard let newAnchor = newAnchor, let sampleObjects = sampleObjects else{
                    return
                }
                self.anchor = newAnchor
                self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
        return (heartRateQuery)
    }
    
    func readingHeartRate(){
        var today = Date()
        if let query = HealthKitSetupAssistant.createHeartRateStreamingQuery(today){
            self.heartRateQuery = query
            
            
        }
    }*/
    
}

