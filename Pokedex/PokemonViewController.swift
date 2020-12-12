//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by marcelo on 04/12/2020.
//  Copyright © 2020 marcelo. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var spriteImage: UIImageView!
    
    var pokemon: Pokemon!
    let key = "caughtList"

    override func viewDidLoad() {
        
        type1Label.text = ""
        type2Label.text = ""
        
        super.viewDidLoad()
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) {
            (data, response, error) in
            guard let data = data else {
                return
                
            }
            do{
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async {
                    if UserDefaults.standard.array(forKey: self.key) == nil {
                        UserDefaults.standard.set([String](), forKey: self.key)
                    }
                    let a:Array = UserDefaults.standard.array(forKey: self.key)!
                    if a.contains(where: { $0 as! String == self.pokemon.name }) {
                        self.pokemon.caught = true
                    }
                    else{
                        self.pokemon.caught = false
                    }
                    self.nameLabel.text = self.pokemon.name.prefix(1).uppercased() + self.pokemon.name.dropFirst()
                    let spriteUrl = URL(string: pokemonData.sprites.other.artwork.front_default)!
                    do{
                        let data = try Data(contentsOf: spriteUrl)
                        self.spriteImage.image = UIImage(data: data)
                    }catch let spriteError{
                        print(spriteError)
                    }
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }                        
                    }
                    
                    self.catchButton.setTitle(self.pokemon.caught ? "Release" : "Catch!", for: .normal)
                }
            }catch let error {
                print("\(error)")
            }
            
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        var newList = [Any]()
        newList = UserDefaults.standard.array(forKey: key) ?? [String]()
        let currentlyCaught = newList.contains(where: { $0 as! String == pokemon.name})
        if currentlyCaught {
            newList.remove(at: newList.firstIndex(where: { $0 as! String == pokemon.name })!)
        }
        else {
            newList.append(pokemon.name)
        }
        UserDefaults.standard.set(newList, forKey: key)
        
        pokemon.caught = !currentlyCaught
        if pokemon.caught {
            catchButton.setTitle("Release", for: .normal)
        }
        else{
            catchButton.setTitle("Catch!", for: .normal)
        }
    }
    
    
}
