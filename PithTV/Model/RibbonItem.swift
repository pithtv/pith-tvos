//
//  RibbonItem.swift
//  PithTV
//
//  Created by Christoph Cantillon on 05/11/2022.
//

import Foundation

struct RibbonItem : Decodable {
    var channelId: String
    var item: ChannelItem
}

enum ItemType : String, Codable {
    case container, file
}

struct ItemImage : Codable {
    var url: String
    var width: Int?
    var height: Int?
    var language: String?
}
struct ChannelItem : Codable, Identifiable {

    var creationTime: String?
    var modificationTime: String?
    var type: ItemType = .file
    var id: String?
    var title: String
    var overview: String?
    var genre: String?
    var mimetype: String?
    var playable: Bool?
    var fileSize: UInt?
    var dateScanned: String?
    var unavailable: Bool?
    var backdrop: String?
    var poster: String?
    var banner: String?
    var banners: [ItemImage]?
    var posters: [ItemImage]?
    var backdrops: [ItemImage]?

//    var subtitles: Subtitle[]?
//    var playState: IPlayState?
    var releaseDate: String?
}
