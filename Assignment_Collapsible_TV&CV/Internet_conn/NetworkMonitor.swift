//
//  NetworkMonitor.swift
//
//  Created by Arya Kulkarni on 27/01/25.
//
import Foundation
import Network  //network connections to send and receive data 

class NetworkMonitor {
    static let shared = NetworkMonitor() //tracks the internet connection status and notify
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Network")
    var isConnected: Bool = false
    
    
    // Define the closure that will be triggered on network status change
    var onNetworkStatusChanged: ((Bool) -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            DispatchQueue.main.async {
                // Call the closure to notify when the network status changes
                print(self?.isConnected)
                self?.onNetworkStatusChanged?(self?.isConnected ?? false) //gives boolean value
            }
        }
        monitor.start(queue: queue)
    }
}
//This class continuously monitors the network connection status.
//When the network status changes, it updates the isConnected variable and calls the onNetworkStatusChanged closure to notify other parts of the app.
//This is useful for handling network-dependent features, like showing an alert when the device is offline.


