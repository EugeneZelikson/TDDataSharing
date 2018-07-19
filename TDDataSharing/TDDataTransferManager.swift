//
//  TDDataTransferManager.swift
//  TDDataSharing
//
//  Created by TopDevs on 6/7/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

import UIKit

/// A type representing an error value that can be thrown.
public enum TDDataTransferError: Error {
    case unresolvedDataType
    case noDataToSend
    case noDataToReceive
    case couldNotConvertModelIntoData
    case someDataHasLost
    case applicationNotFound
    case couldNotConvertDataIntoModel
    case anyErroReason(String)
    
    /// Description of the error
    func description() -> String {
        var reason = ""
        switch self {
        case .noDataToReceive:
            reason = "No data to receive"
        case .couldNotConvertModelIntoData:
            reason = "Could not convert model into data"
        case .applicationNotFound:
            reason = "Application wasn't found"
        case .unresolvedDataType:
            reason = "You try to send unresolved data type"
        case .noDataToSend:
            reason = "No data to send"
        case .someDataHasLost:
            reason = "It looks like some data was lost"
        case .couldNotConvertDataIntoModel:
            reason = "Could not convert data into model"
        case .anyErroReason(let message):
            reason = message
        }
        return reason
    }
    
    public var localizedDescription: String {
        get {
            return description()
        }
    }
}

/// The manager controls the transmission and reception of data through the clipboard. This is an easy way to organize the interconnection of your distributed applications within a single device.
class TDDataTransferManager: NSObject {

    convenience init(withRequestModel model: TDRequestModel) {
        self.init()
        requestModel = model
    }
    
    var requestModel: TDRequestModel!
    
    var payload: [Any] = []
    
    var addition: [[String: String]] = []
    
/** A method that sends any data to another application.
     
 - parameter completion: a completion block that returns a success or failure message.
 - parameter sent: A string to use
 - parameter error: A string to use
 */
    public func sendPayload(completion: ((_ sent: Bool,_ error: TDDataTransferError?)->Void)? = nil) {
        if payload.count != 0 || addition.count != 0{
            send(payload, toApplicationWithScheme: requestModel.destinationURLScheme!, completion: completion)
        } else {
            completion?(false, TDDataTransferError.noDataToSend)
        }
    }
    
    private func send(_ payload: [Any], toApplicationWithScheme scheme: String, completion: ((_ sent: Bool,_ error: TDDataTransferError?)->Void)? = nil) {
        
        let pasteboard = UIPasteboard.general
    
        let pasteboardItems = pasteboard.items
        requestModel.dataContainer.pasteboardOldItems = encode(pasteboardItems)
        
        requestModel.dataContainer.payload = payload.map({ (object) -> Data in
            return encode(object)!
        })
        do {
            
            let requestData = try requestModel.encode()
            
            var json = [["requestModel": pasteboard.send(DataWithUniqueIdentifier: requestData)]]
            
            json.append(contentsOf: addition)
            
            let url = self.url(forSheme: scheme, withQueryDictionary: json)
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if success == true {
                        completion?(success, nil)
                    } else {
                        completion?(success, TDDataTransferError.applicationNotFound)
                    }
                }
            } else {
                if UIApplication.shared.canOpenURL(url) == false {
                    completion?(false, TDDataTransferError.applicationNotFound)
                    return
                }
                completion?(true, nil)
                UIApplication.shared.openURL(url)
            }
            
        } catch {
            completion?(false, TDDataTransferError.anyErroReason(error.localizedDescription))
        }
        
    }
    
    /**
     This method receives URL scheme with query that contains unique identifier for pasteboard with data.
     - parameter url: incoming url
     */
    public func receivePayload(fromURL url:URL) throws -> [Any?] {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            throw TDDataTransferError.noDataToReceive
        }
        let pasteboard = UIPasteboard.general
        
        var values: [Any?] = []
        
        for query in queryItems {
            let key = query.name
            
            let value = query.value!
            
            if key.elementsEqual("requestModel") {
                guard let data = pasteboard.data(forPasteboardType: value) else {
                    continue
                }
                do {
                    let model = try TDRequestModel.decode(data: data)
                    requestModel = model
                    
                } catch {
                    throw error
                }
                
                do {
                    values = try requestModel.dataContainer.payload.map({ (object) -> Any? in
                        return try anyObject(FromData: object)
                    })
                } catch {
                    throw error
                }
                
            } else {
                addition.append([key : value])
            }
        }
        
        if let items = try? anyObject(FromData: requestModel.dataContainer.pasteboardOldItems) as! [[String: Any]] {
            pasteboard.setItems(items, options: [:])
        }
        
        return values
    }
    
    /// This method creates URL for opening another application with parameters
    /// - parameter scheme: URL scheme to application
    /// - parameter dictionary: object with keys and string value for query of result url
    private func url(forSheme scheme: String, withQueryDictionary payload: [[String : String]]) -> URL {
        
        var queryItems:[URLQueryItem] = []
        for dictionary in payload {
            let keys = Array(dictionary.keys)
            for key in keys {
                queryItems.append(URLQueryItem(name: key, value: dictionary[key]))
            }
        }
        var urlComponents = URLComponents(string: "\(scheme)://")
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            fatalError("")
        }
        
        return url
    }
    
}

extension String {
    
    /// This method generates random string with seted length of string
    /// - parameter length: length of result string
    fileprivate static func randomString(withCharactersCount length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map { (char) -> String in
            return String(char)
        }
        var randomString = ""
        for _ in 0 ..< length {
            let randomPosition = arc4random_uniform(UInt32(characters.count))
            randomString += characters[Int(randomPosition)]
        }
        return randomString
    }
    
}

extension UIPasteboard {
    /**
     The method sends data and returns the data identifier in the clipboard.
     - parameter data: data to send.
     - returns: A random string on which you can take data from the clipboard.
     */
    func send(DataWithUniqueIdentifier data: Data) -> String {
        let identifier = String.randomString(withCharactersCount: 10)
        setData(data, forPasteboardType: identifier)
        return identifier
    }
    
}
