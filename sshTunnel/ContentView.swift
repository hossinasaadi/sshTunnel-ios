//
//  ContentView.swift
//  sshTunnel
//
//  Created by HossinAsaadi on 7/23/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vpn: VPN = VPN()

    var body: some View {
        Text("SSH Tunnel").font(.headline)
        List {
            Toggle(isOn: $vpn.toggle) {
                    Text("Connect SSH")
                
            }
            .onChange(of: vpn.toggle) { value in
                vpn.onToggle()
            }
        }
        .padding()
        .onAppear(){
            vpn.viewDidLoad()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
