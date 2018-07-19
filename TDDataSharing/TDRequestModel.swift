//
//  TDRequestModel.swift
//  TDDataSharing
//
//  Created by TopDevs on 6/7/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

import Foundation

struct TDRequestModel: TDCodability {
    
    /// Container of transmitted data.
    var dataContainer: TDDataContainer = TDDataContainer()
    /// Scheme for calling the destination application.
    var destinationURLScheme: String?
    /// A scheme for feedback from your application from the destination application.
    var sourceURLScheme: String?
    
    /**
     Initial method of model with sourceURL and destination
     - parameter sourceURLString: A scheme for feedback from your application from the destination application.
     - parameter destinationURLString: Scheme for calling the destination application.
     */
    init(withSourceURLScheme sourceURLString: String, destinationURLScheme destinationURLString: String) {
        destinationURLScheme = destinationURLString
        sourceURLScheme = sourceURLString
    }

}

/// A class that includes all the necessary data of the source application, and an array of encrypted data sent from the application.
class TDDataContainer: NSObject, TDCodability {

    /// Display name of source application
    var sourceApplicationName: String!
    /// Source application identifier
    var sourceApplicationIdentifier: String!
    /// Source application version
    var sourceApplicationVersion: String!
    /// Source application build vesrsion
    var sourceApplicationBuild: String!
    /// Array of encoded objects
    var payload: [Data]!
    /// Backup of data from the clipboard.
    var pasteboardOldItems: Data!
    
    override init() {
        super.init()
        
        guard let infoPlist = Bundle.main.infoDictionary else {
            fatalError("Could not found info plist!")
        }
        sourceApplicationName = infoPlist["CFBundleDisplayName"] as? String
        sourceApplicationIdentifier = infoPlist["CFBundleIdentifier"] as? String
        sourceApplicationVersion = infoPlist["CFBundleShortVersionString"] as? String
        sourceApplicationBuild = infoPlist["CFBundleVersion"] as? String
    }
    
}


