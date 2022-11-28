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

enum MediaItemType : String, Codable {
    case movie, show, season, episode
}

struct ItemImage : Codable {
    var url: String
    var width: Int?
    var height: Int?
    var language: String?
}
struct ChannelItem : Codable, Identifiable, Hashable {
    var id: String
    var creationTime: String?
    var modificationTime: String?
    var type: ItemType = .file
    var mediatype: MediaItemType?
    var rating: Float?
    var title: String
    var overview: String?
    var genre: [String]?
    var mimetype: String?
    var playable: Bool?
    var fileSize: UInt?
    var dateScanned: String?
    var unavailable: Bool?
    var banners: [ItemImage]?
    var posters: [ItemImage]?
    var backdrops: [ItemImage]?

//    var subtitles: Subtitle[]?
//    var playState: IPlayState?
    var releaseDate: String?
    
    func getReleaseDate() -> Date? {
        if let date = releaseDate {
            return Formatter.iso8601withFractionalSeconds.date(from: date)
        }
        return nil
    }
    
    var seasons: [ChannelItem]?
    var episodes : [ChannelItem]?
    
    static func == (lhs: ChannelItem, rhs: ChannelItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ItemAndStream : Codable {
    var item: ChannelItem
    var stream: Stream
}

struct Stream : Codable {
    var url: String
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
