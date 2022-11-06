//
//  ModelData.swift
//  PithTV
//
//  Created by Christoph Cantillon on 04/11/2022.
//

import Foundation

var channels: [Channel] = load("channels.json")
var ribbons: [Ribbon] = load("ribbons.json")
var recentlyAdded: [RibbonItem] = load("recentlyAdded.json")
var videoUrl: String = "http://192.168.1.104:3333/pith/stream/undefined/Series/Grey's%20Anatomy/Season%2019/Grey's%20Anatomy%20-%20S19E05%20-%20When%20I%20Get%20to%20the%20Border%20WEBRip-1080p.mkv"

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
