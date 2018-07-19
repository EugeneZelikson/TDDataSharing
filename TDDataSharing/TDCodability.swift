//
//  TDCodability.swift
//  TDDataSharing
//
//  Created by TopDevs on 6/8/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

import UIKit


/// Convinience protocol which is based on Codable with extension as decode and encode.
protocol TDCodability: Codable { }

extension TDCodability {
    /// Type of member object 
    typealias T = Self
    
    /// Encode fast way to encode member of TDCodability to data.
    /// - returns: encoded date of the original object.
    func encode() throws -> Data {
        let data = try JSONEncoder().encode(self)
        return data
    }
    
    /// Decode is an easy way to decode member of protocol TDCodability back to object of any class
    /// - parameter data: target data to decode to object
    /// - returns: member of protocol which was encoded in the data.
    static func decode(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension TDDataTransferManager {
    
    /**
     Decodes and returns the object graph previously encoded by NSKeyedArchiver and stored in a given NSData object.
     - parameter data: An object graph previously encoded by NSKeyedArchiver
     - returns: The object graph previously encoded by NSKeyedArchiver and stored in data.
     */
    func anyObject(FromData data: Data) throws -> Any {
        
        guard let anyObject = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            guard let anyImage = UIImage(data: data) else {
                throw TDDataTransferError.unresolvedDataType
            }
            
            return anyImage
        }
        
        return anyObject
        
    }
    
    /**
     Object encoder returns the data for the any object.
     
     - parameter value: any object what can be encoded.
     - returns: An Data object containing the encoded form of the object
     */
    func encode(_ value: Any?) -> Data?{
        var anyData: Data?
        if let any = value {
            if let image = value as? UIImage {
                anyData = UIImagePNGRepresentation(image)
            } else {
                anyData = NSKeyedArchiver.archivedData(withRootObject: any)
            }
        }
        return anyData
    }
}
