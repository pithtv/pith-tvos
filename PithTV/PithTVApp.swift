//
//  PithTVApp.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI
import Network

@main
struct PithTVApp: App {
    @State var pith: Pith?
    
    init() {
        URLCache.shared = URLCache(memoryCapacity: 120_000_000, diskCapacity: 1000_000_000)
    }
    
    var body: some Scene {
        WindowGroup {
            if(pith != nil) {
                ContentView(pith: pith!)
            } else {
                ProgressView()
                Text("Searching for Pith on your network").task {
                    let parameters = NWParameters()
                    parameters.includePeerToPeer = true
                    let browser = NWBrowser(for: .bonjour(type: "_pith._tcp", domain: "local."), using: parameters)
                    browser.browseResultsChangedHandler = { results, changes in
                        for result in results {
                            print(result)
                            switch(result.endpoint) {
                            case let .service(name, type, domain, _):
                                print("Service")
                                
                                let service = NetService(domain: domain, type: type, name: name)
                                
                                BonjourResolver.resolve(service: service) { result in
                                    switch result {
                                    case .success(let (hostName, port)):
                                        print("did resolve, host: \(hostName)")
                                        pith = Pith(baseUrl: URL(string: "http://\(hostName):\(port)")!)
                                    case .failure(let error):
                                        print("did not resolve, error: \(error)")
                                    }
                                }
                                
                                break;
                            default:
                                print("Unknown")
                            }
                        }
                    }
                    browser.stateUpdateHandler = {
                        state in print("\(state)")
                    }
                    browser.start(queue: .main)
                    print("Browsing for Pith instances")
                }
            }
        }
    }
}
