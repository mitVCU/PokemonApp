//
//  Endpoint.swift
//  Pokemon
//
//  Created by Mit Amin on 10/15/26.
//

import Foundation

enum APIError: Error {
    case urlReqErr
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    func makeRequest() throws -> URLRequest {
        guard var urlComponent = URLComponents(string: baseURL) else { throw APIError.urlReqErr }
        urlComponent.queryItems = queryItems
        
        var urlReq = URLRequest(url: urlComponent.url!)
        urlReq.httpMethod = "GET"
        return urlReq
    }
}


struct PokemonListEndpoint: Endpoint {
    let path: String = ""
    
    let queryItems: [URLQueryItem] = []
    
    var baseURL: String = "https://pokeapi.co/api/v2/pokemon"
}


struct PokemonList: Decodable {
    var count : Int
    var next : String
    var previous : String?
    var results : [PokemonListOBJ]
}

struct PokemonListOBJ: Decodable {
    var name: String
    var url: String
}

struct Pokemon: Decodable {
    var id: Int
    var sprites: Sprite
}

struct Sprite: Decodable {
    var front_default: String
}

struct APIClient {
    func fetch<E: Decodable>(url: URLRequest, type: E.Type) async throws -> E {
        do {
            let (data, response) = try await URLSession.shared.data(for: url)

            // check response code
            
            let output = try JSONDecoder().decode(E.self, from: data)
            return output
            
        } catch {
            print("api client error \(error)")
            throw error
        }
    }
}

