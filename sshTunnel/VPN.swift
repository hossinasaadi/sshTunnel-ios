//
//  VPN.swift
//  sshTunnel
//
//  Created by HossinAsaadi on 7/23/23.
//

import Foundation
class VPN: ObservableObject {
    @Published var toggle = false
    
    var manager = VPNManager.shared()
    func getVpnStatus() -> Bool{
        return (manager.manager.connection.status != .disconnected &&
                manager.manager.connection.status != .disconnecting &&
                manager.manager.connection.status != .invalid
        )
    }
    @objc func updateStatus() {
        toggle = (manager.manager.connection.status != .disconnected &&
                  manager.manager.connection.status != .disconnecting &&
                  manager.manager.connection.status != .invalid
        )

    }
    func viewDidLoad() {
#if !targetEnvironment(simulator)
        
        manager.loadVPNPreference() { error in
            guard error == nil else {
                print("load VPN preference failed: \(error.debugDescription)")
                return
            }
            self.updateStatus()
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateStatus), name: NSNotification.Name.NEVPNStatusDidChange, object: self.manager.manager.connection)
        }
#endif
    }
    func onToggle(){
        manager.enableVPNManager() { error in
            guard error == nil else {
                print("enable VPN failed: \(error.debugDescription)")
                return
            }
            self.manager.toggleVPNConnection() { error in
                guard error == nil else {
                    
                    fatalError("toggle VPN connection failed: \(error.debugDescription)")
                }
            }
            
        }

    }

}
