//
//  NetworkChecker.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation
import Network

protocol NetworkAvailabilityChecker {
    var isNetworkAvailable: Bool { get }
    func startMonitoringNetwork()
}

class NetworkAvailabilityManager: NetworkAvailabilityChecker {
    private let monitor = NWPathMonitor()
    private(set) var isNetworkAvailable = true
    
    init() {
        startMonitoringNetwork()
    }
    
    func startMonitoringNetwork() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
