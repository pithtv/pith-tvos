//
//  TvShowDetails.swift
//  PithTV
//
//  Created by Christoph Cantillon on 24/11/2022.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct TvShowDetails : View {
    var pith: Pith
    var channelId: String
    var item: ChannelItem
    
    @State var selectedSeason : ChannelItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                AsyncImage(url: pith.imgUrl(item.banners!.first!.url),
                           content: {img in img.resizable().aspectRatio(contentMode: .fit)},
                           placeholder: {ProgressView()})
                
                if let overview = item.overview {
                    Text(overview)
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(item.seasons ?? []) {
                            season in
                            
                            Button(action: {
                                selectedSeason = season
                            }) {
                                Text(season.title)
                                    .if(selectedSeason == season) {
                                        view in view.foregroundColor(.blue)
                                    }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.padding(80)
                }.padding(-80)
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(selectedSeason?.episodes ?? []) {
                        episode in
                        NavigationLink(destination: VideoView(
                            pith: pith,
                            channel: channelId,
                            item: episode)) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text(episode.title)
                                        .font(.title3)
                                    if let airDate = episode.getReleaseDate() {
                                        Text("Aired \(airDate.formatted())")
                                            .font(.subheadline)
                                    }
                                    if let overview = episode.overview {
                                        Text(overview)
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }.disabled(episode.unavailable ?? false)
                    }
                }
                
                Spacer()
            }
            .frame(width: 1600)
            .padding(80)
        }
        .padding(-80)
        .background(Backdrop(pith: pith, item: item))
    }
}

struct TvShowDetails_Previews: PreviewProvider {
    static var previews: some View {
        TvShowDetails(pith: Pith(baseUrl: URL(string: "http://horace:3333")!),
                      channelId: "sonarr",
                      item: barry,
                      selectedSeason: barry.seasons?.first)
    }
}
