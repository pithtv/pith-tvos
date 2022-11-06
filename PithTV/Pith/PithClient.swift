//
//  PithClient.swift
//  PithTV
//
//  Created by Christoph Cantillon on 06/11/2022.
//

import Foundation

public actor PithClient {
    private let session: URLSession
    private let baseUrl: URL
    
    init(baseUrl: URL) {
        session = URLSession(configuration: .default)
        self.baseUrl = baseUrl
    }
    
    func queryChannels() async throws -> [Channel] {
        return try await get(url: "/rest/channels")
    }
    
    func queryRibbons() async throws -> [Ribbon] {
        return try await get(url: "/rest/ribbons")
    }
    
    func queryItemAndStream(channel: String, itemId: String) async throws -> ItemAndStream {
        return try await get(url: "/rest/channel/\(channel)/stream/\(itemId)")
    }
    
    func queryRibbonItems(_ id: String) async throws -> [RibbonItem] {
        return try await get(url: "/rest/ribbons/\(id)")
    }
    
    private func get<T: Decodable>(url: String) async throws -> T {
        return try await send(request: try makeRequest(url: url, method: "GET"))
    }
    
    private func makeRequest(url: String, method: String) throws -> URLRequest {
        var request: URLRequest = URLRequest(url: baseUrl.appending(path: url))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func send<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request, delegate: nil)
        try validate(response);
        let decode = JSONDecoder()
        return try decode.decode(T.self, from: data)
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        if !(200..<300).contains(httpResponse.statusCode) {
            throw PithError.invalidStatusCode(httpResponse.statusCode, url: response.url)
        }
    }
}

enum PithError : Error {
    case invalidStatusCode(_ statusCode: Int, url: URL?)
}
