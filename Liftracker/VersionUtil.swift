//
//  VersionUtil.swift
//  Liftracker
//
//  Created by John McAvey on 2/25/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import os.log

// TODO: Better logging and more reuse
class VersionUtil {
    static let lastAppVersion: KVEntry<String> = defaultsEntry("\(preferencePrefix).previous.app.version")
    static let lastMarketingVersion: KVEntry<String> = defaultsEntry("\(preferencePrefix).previous.marketing.version")
    
    /**
     Checks the bundle version identifiers to see if there has been a change since the previous version. If there has been, then it will return a `VersionChange` object representing the change in versions.
     */
    public static func versionDifference() -> VersionChange? {
        if let current = getCurrentVersion(),
            let previous = getPreviousVersion() {
            return VersionChange(
                previous: previous,
                current: current
            )
        }
        return nil
    }
    
    public static func getCurrentVersion() -> AppVersion? {
        guard let appVersionStr = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return nil
        }
        guard let releaseVersion = Int(appVersionStr) else {
            os_log("Release version must be an integer, not %s",
                log: ui_log,
                type: .error, appVersionStr)
            return nil
        }
        guard let marketingVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return nil
        }
        
        return AppVersion(
            marketing: marketingVersion,
            release: releaseVersion
        )
    }
    
    public static func getPreviousVersion() -> AppVersion? {
        guard let releaseStr: String = lastAppVersion.get() else {
            return nil
        }
        
        guard let release = Int(releaseStr) else {
            return nil
        }
        
        guard let marketing: String = lastMarketingVersion.get() else {
            return nil
        }
        return AppVersion(
            marketing: marketing,
            release: release
        )
    }
    
    public static func updateVersionStore() {
        guard let appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return
        }
        guard let marketingVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return
        }
        lastAppVersion.set( appVersion )
        lastMarketingVersion.set( marketingVersion )
    }
}

public struct VersionChange {
    let previous: AppVersion
    let current: AppVersion
}

public struct AppVersion: Equatable {
    let marketing: String
    let release: Int
    
    static public func ==(lhs: AppVersion, rhs: AppVersion) -> Bool {
        return lhs.marketing == rhs.marketing && lhs.release == rhs.release
    }
}
