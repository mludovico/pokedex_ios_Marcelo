//
//  Pokemon.swift
//  Pokedex
//
//  Created by marcelo on 04/12/2020.
//  Copyright © 2020 marcelo. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct SpriteUrl: Codable {
    let front_default: String
}

struct Other: Codable {
    var artwork: SpriteUrl
    
    enum CodingKeys: String, CodingKey {
        case artwork = "official-artwork"
    }
}

struct Sprites: Codable {
    let other: Other
}

struct Pokemon: Codable {
    let name: String
    let url: String
    var caught: Bool {
        get { return _caught ?? false}
        set { _caught = newValue}
    }
    
    private var _caught: Bool?
    
    enum CodingKeys: String, CodingKey {
        case _caught = "caught"
        case name
        case url
    }
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: Sprites
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}
