//
//  PithTVApp.swift
//  PithTV
//
//  Created by Christoph Cantillon on 03/11/2022.
//

import SwiftUI

@main
struct PithTVApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(pith: Pith(baseUrl: URL(string: "http://horace:3333")!))
        }
    }
}
