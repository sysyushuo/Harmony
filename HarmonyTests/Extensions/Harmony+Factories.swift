//
//  Harmony+Factories.swift
//  HarmonyTests
//
//  Created by Riley Testut on 1/8/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import Foundation
import CoreData

@testable import Harmony

extension NSManagedObjectContext
{
    static var harmonyFactoryDefault: NSManagedObjectContext!
}

extension RemoteRecord
{
    class func make(identifier: String = UUID().uuidString, versionIdentifier: String = UUID().uuidString, versionDate: Date = Date(), status: ManagedRecordStatus = .normal, context: NSManagedObjectContext = .harmonyFactoryDefault) -> RemoteRecord
    {
        let record = RemoteRecord(identifier: identifier, versionIdentifier: versionIdentifier, versionDate: versionDate, status: status, managedObjectContext: context)
        return record
    }
}
