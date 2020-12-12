//
//  ViewController.swift
//  Pokedex
//
//  Created by marcelo on 04/12/2020.
//  Copyright © 2020 marcelo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    var pokemon: [Pokemon] = []
    var filteredList: [Pokemon] = []
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) {
            (data, response, error) in
            guard let data = data else {
                return
                
            }
            do{
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.filteredList = pokemonList.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }catch let error {
                print("\(error)")
            }
            
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredList = pokemon.filter({ (item) -> Bool in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        else{
            filteredList = pokemon
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: filteredList[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = filteredList[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

