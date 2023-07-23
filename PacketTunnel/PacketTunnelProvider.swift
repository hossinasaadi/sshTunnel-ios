//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by HossinAsaadi on 7/23/23.
//

import NetworkExtension
import SshLib
class PacketTunnelProvider: NEPacketTunnelProvider {
    var tunnelFd: Int32? {
        var buf = [CChar](repeating: 0, count: Int(IFNAMSIZ))

        for fd: Int32 in 0 ... 1024 {
            var len = socklen_t(buf.count)

            if getsockopt(fd, 2 /* IGMP */, 2, &buf, &len) == 0 && String(cString: buf).hasPrefix("utun") {
                return fd
            }
        }

        return packetFlow.value(forKey: "socket.fileDescriptor") as? Int32
    }

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let tunnelNetworkSettings = createTunnelSettings()
        self.setTunnelNetworkSettings(tunnelNetworkSettings)

        let localSocks = "127.0.0.1:10801"
        let sshAddress = "1.1.1.1:22"
        let sshUser = "root"
        let sshPass = "1234"
        
        let udpGwRemote = "1.1.1.1:7300"
        
        
        DispatchQueue.global(qos: .userInitiated).async {

            NSLog("run ssh : \(SshlibInitSSH(sshAddress,localSocks,sshUser,sshPass))")

        }
        DispatchQueue.global(qos: .userInitiated).async {
            
            let argv = ["tun2socks",
                        "--netif-ipaddr",
                        "240.0.0.4",
                        "--netif-netmask",
                        "255.255.255.0",
                        "--loglevel",
                        "debug",
                        "--socks-server-addr",
                        localSocks,
                        "--udpgw-remote-server-addr",
                        udpGwRemote,
            ]
            var cargs = argv.map { strdup($0) }

            NSLog("run tun2socks_main: \(tun2socks_main(Int32(argv.count),&cargs,self.tunnelFd!,Int32(1500)))")


        }

        completionHandler(nil)

    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
    func createTunnelSettings() -> NEPacketTunnelNetworkSettings  {
        let newSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "240.0.0.10")
        newSettings.ipv4Settings = NEIPv4Settings(addresses: ["240.0.0.2"], subnetMasks: ["255.255.255.0"])
        newSettings.ipv4Settings?.includedRoutes = [NEIPv4Route.`default`()]
        newSettings.proxySettings = nil
        newSettings.dnsSettings = NEDNSSettings(servers: ["8.8.8.8"])
        newSettings.mtu = (1500) as NSNumber
        
        return newSettings
    }
}
