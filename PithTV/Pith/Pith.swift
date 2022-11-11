//
//  Pith.swift
//  PithTV
//
//  Created by Christoph Cantillon on 06/11/2022.
//

import Foundation

class Pith : ObservableObject {
    let client: PithClient
    let baseUrl: URL
    
    @Published var channels: [Channel]?
    @Published var ribbons: [Ribbon]?
    @Published var ribbonItems: Dictionary<String, [RibbonItem]> = Dictionary()
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl;
        self.client = PithClient(baseUrl: baseUrl)
    }
    
    @MainActor
    func load() async throws {
        channels = try await client.queryChannels()
        ribbons = try await client.queryRibbons()
        
        for ribbon in ribbons! {
            print(ribbon.id)
            ribbonItems[ribbon.id] = try await client.queryRibbonItems(ribbon.id)
        }
    }
    
    func queryItemAndStream(channel: String, itemId: String) async throws -> ItemAndStream {
        return try await client.queryItemAndStream(channel: channel, itemId: itemId);
    }
    
    func listChannel(channelId: String, containerId: String?) async throws -> [ChannelItem] {
        return try await client.queryChannelItems(channelId: channelId, containerId: containerId)
    }
    
    func imgUrl(_ url: String) -> URL {
        let url = URL(string: "\(baseUrl.absoluteString)/scale/\(url)?size=original")
        return url!;
    }
}
