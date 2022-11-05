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
