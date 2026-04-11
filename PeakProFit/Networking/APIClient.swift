//
//  ApiNetwork.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 15/3/26.
//

import Foundation


enum APIClientError: Error {
    case badURL
    case decoding(Error)
    case badStatus(Int)
    case notFound
    case serverError
    case unowned
}

extension APIClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .decoding:
            return "We couldn't load data right now. Please try again."
        case .badStatus(let code):
            return "The server returned an unexpected status code: \(code)."
        case .notFound:
            return "We couldn't find exercises to show right now."
        case .serverError:
            return "The server failed while processing the request."
        case .unowned:
            return "Invalid or unsupported server response."
        }
    }
}

final class APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    func get<T: Decodable>(_ path: String) async throws -> T {
        let (data, _, url) = try await performGet(path)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            let rawBody = String(data: data, encoding: .utf8) ?? "<non-utf8>"
            print("[APIClient] Decoding error for \(url.absoluteString): \(error)")
            print("[APIClient] Raw response: \(rawBody.prefix(600))")
            throw APIClientError.decoding(error)
        }
    }

    func getData(_ path: String, cacheFileName: String? = nil) async throws -> URL? {
        let (data, _, _) = try await performGet(path)
        guard let cacheFileName else { return nil }
        return try saveToCaches(data: data, fileName: cacheFileName)
    }

    private func performGet(_ path: String) async throws -> (Data, HTTPURLResponse, URL) {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw APIClientError.badURL }
        guard let rapidApiHost = baseURL.host(), !rapidApiHost.isEmpty else {
            throw APIClientError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.rapidApiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(rapidApiHost, forHTTPHeaderField: "X-RapidAPI-Host")

        let (data, response): (Data, URLResponse)

        print("[APIClient] GET \(url.absoluteString)")
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            print("[APIClient] GET \(url.absoluteString) -> transport error: \(error.localizedDescription)")
            throw error
        }

        let http = response as? HTTPURLResponse
        if let status = http?.statusCode {
            print("[APIClient] GET \(url.absoluteString) -> \(status)")
        } else {
            print("[APIClient] GET \(url.absoluteString) -> non-HTTP response")
        }

        guard let http else { throw APIClientError.unowned }
        let status = http.statusCode
        if status == 404 { throw APIClientError.notFound }
        if (500...599).contains(status) { throw APIClientError.serverError }
        guard (200...299).contains(status) else { throw APIClientError.badStatus(status) }
        return (data, http, url)
    }

    private func saveToCaches(data: Data, fileName: String) throws -> URL {
        let fileManager = FileManager.default
        let cacheRoot = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let cacheRoot else { throw APIClientError.unowned }

        let imagesDir = cacheRoot.appendingPathComponent("exercise-images", isDirectory: true)
        if !fileManager.fileExists(atPath: imagesDir.path) {
            try fileManager.createDirectory(at: imagesDir, withIntermediateDirectories: true)
        }

        let fileURL = imagesDir.appendingPathComponent(fileName)
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }
    
}
