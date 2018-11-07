//
//  RemoteFile.swift
//  Harmony
//
//  Created by Riley Testut on 11/7/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import Foundation
import CoreData

extension RemoteFile
{
    private enum CodingKeys: String, CodingKey
    {
        case identifier
        case sha1Hash
        case remoteIdentifier
        case versionIdentifier
    }
}

@objc(RemoteFile)
public class RemoteFile: NSManagedObject, Codable
{
    @NSManaged public var identifier: String
    @NSManaged public var sha1Hash: String
    
    @NSManaged public var remoteIdentifier: String
    @NSManaged public var versionIdentifier: String
    
    @NSManaged public var localRecord: LocalRecord?
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(remoteIdentifier: String, versionIdentifier: String, metadata: [HarmonyMetadataKey: String], context: NSManagedObjectContext) throws
    {
        guard let identifier = metadata[.relationshipIdentifier], let sha1Hash = metadata[.sha1Hash] else { throw RemoteFileError(code: .invalidMetadata) }
        
        super.init(entity: RemoteFile.entity(), insertInto: context)
        
        self.identifier = identifier
        self.sha1Hash = sha1Hash
        self.remoteIdentifier = remoteIdentifier
        self.versionIdentifier = versionIdentifier
    }
        
    public required init(from decoder: Decoder) throws
    {
        guard let context = decoder.managedObjectContext else { throw RemoteFileError(code: .nilManagedObjectContext) }
        
        super.init(entity: RemoteFile.entity(), insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.sha1Hash = try container.decode(String.self, forKey: .sha1Hash)
        self.remoteIdentifier = try container.decode(String.self, forKey: .remoteIdentifier)
        self.versionIdentifier = try container.decode(String.self, forKey: .versionIdentifier)
        
        context.insert(self)
    }
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.sha1Hash, forKey: .sha1Hash)
        try container.encode(self.remoteIdentifier, forKey: .remoteIdentifier)
        try container.encode(self.versionIdentifier, forKey: .versionIdentifier)
    }
    
    public override func willSave()
    {
        super.willSave()
        
        guard !self.isDeleted else { return }
        
        if self.localRecord == nil
        {
            self.managedObjectContext?.delete(self)
        }
    }
}
