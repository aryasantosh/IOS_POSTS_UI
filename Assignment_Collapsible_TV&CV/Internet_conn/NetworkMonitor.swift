//
//  NetworkMonitor.swift
//  Assignment_Collapsible_TV&CV
//
//  Created by Arya Kulkarni on 27/01/25.
//
import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
            }
        }
        
        
        monitor.start(queue: queue)
    }
}




