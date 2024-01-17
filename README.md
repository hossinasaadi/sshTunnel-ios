# SSH Tunnel (iOS and Mac) SwiftUI

sshTunnel is a swiftUI application that support tunnel through ssh with udp gateway (udpgw)

AppStore : [SSH VPN - Client for SSH](https://apps.apple.com/us/app/ssh-vpn-client-for-ssh/id6471132702)

used libs : 

SSH Go for Mobile : [ssh-go](https://github.com/hossinasaadi/ssh-go)

BadvpnSwift : [BadvpnSwift](https://github.com/hossinasaadi/BadvpnSwift)



set ssh server parameters :

edit `PacketTunnelProvider.swift`

````bash
let localSocks = "127.0.0.1:10801"
let sshAddress = "1.1.1.1:22"
let sshUser = "root"
let sshPass = "1234"

// udpgw port is 7300 change if you needs
let udpGwRemote = "1.1.1.1:7300"
````

feel free to Contribute :) ❤️
