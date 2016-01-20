//
//  HealthKitManager.swift
//  Liftracker
//
//  Created by John McAvey on 1/9/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class HealthKitManager {
    
    static var store: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        }
        return nil
    }()
    static let dateKey = "startDate"
    static let manager = DataManager.getInstance()
    
    //Publishes all the unpublished weights to healthkit
    static func publishNewWeights() {
        //todo: Implment
    }
    
    //Unpublishes all weight data
    static func resetPublishRecord(){
        //todo: Implement
    }
    
    //Do your very best to sync records without adding duplicates
    static func syncWithHealthKit() {
        //todo: Implement
    }
    
    static func addWeight(weight: Double, date: NSDate = NSDate()) {
        let wt = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let unit = UserPrefs.getUnitString() == "Lbs" ? HKUnit.poundUnit() : HKUnit.gramUnit()
        let value = HKQuantity(unit: unit, doubleValue: weight)
        let sample = HKQuantitySample(type: wt!,
                                        quantity: value,
                                        startDate: date,
                                        endDate: date)
        writeToHK(sample, type: wt!)
    }
    
    static func getWeights(var storeLocation: [Weight], numEntries: Int = 50, predicate: NSPredicate? = nil) -> [HKQuantitySample] {
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        var values = [HKQuantitySample]()
        let weight_query = HKSampleQuery(sampleType: weight!,
                                            predicate: predicate,
                                            limit: numEntries,
                                            sortDescriptors: nil,
                                            resultsHandler: {(query, results, error) in
                                                if let results = results as? [HKQuantitySample] {
                                                    print("Successfully got data.  Retrieved \(results.count) records")
                                                    storeLocation.appendContentsOf(manager.hkToWeight(results))
                                                    values = results
                                                }
                                                else {
                                                    print("There was a problem accessing health kits weight data \n\(error)")
                                                }
                                            })
        store?.executeQuery(weight_query)
        return values
    }
    
    static func writeToHK(sample: HKQuantitySample, type: HKObjectType) -> Bool {
        if hasPermission(type) {
            store?.saveObject(sample, withCompletion: {(success, error) in
                if !success {
                    print("Error encountered while saving to health kit! \(error)")
                }
            })
            return true
        }
        return false
    }
    
    static func requestPermission() -> Bool {
        let activeEnergy = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        var permissions: Bool = false
        let attributes = NSSet(array: [activeEnergy!, weight!]) as! Set<HKSampleType>
        store!.requestAuthorizationToShareTypes(attributes, readTypes: attributes, completion: { (success, error) in
            permissions = success
            if !success {
                print("Problem requesting permissions for healthkit... \n\(error)")
            }
        })
        return permissions
    }
    
    static func executeQuery(query: HKSampleQuery) {
        if hasPermission(query.sampleType) {
            store?.executeQuery(query)
        }
    }
    
    static func hasPermission(type: HKObjectType =
                                    HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!) -> Bool {
        if let status = store?.authorizationStatusForType(type) {
            switch status {
            case .NotDetermined:
                return requestPermission()
            case .SharingDenied:
                return false
            case .SharingAuthorized:
                return true
            }
        }
        return false
    }
    
    static func shouldRequestPermission(type: HKObjectType =
                                              HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!) -> Bool {
        return store?.authorizationStatusForType(type) == .NotDetermined
    }
}