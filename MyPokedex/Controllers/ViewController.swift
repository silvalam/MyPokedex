//
//  ViewController.swift
//  MyPokedex
//
//  Created by Sylvia Lam on 1/23/20.
//  Copyright © 2020 Sylvia Lam. All rights reserved.
//

import UIKit
import PokemonAPI
import SDWebImage

enum SearchState {
    case active
    case inactive
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let reuseIdentifier = "PokemonCell"
    let placeholderImg = UIImage(named: "PlaceholderImage")
    let totalPokemonReleased = 807 // at this point in time: 1-23-2020
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Store all pokemons
    var allPokemons = [PKMPokemon]()
    // Store only pokemons matching search
    var filteredPokemons = [PKMPokemon]()
    
    // Inactive status until search bar text is non empty
    var searchState: SearchState = .inactive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        fetchAllPokemon()
    }
    
    //MARK: Call API to fetch all Pokemon
    func fetchAllPokemon(){
        for pokemonID in 1...totalPokemonReleased {
            PokemonAPI.pokemonService.fetchPokemon(pokemonID) { result in
                switch result {
                case .success(let pokemon):
                    print(pokemon.name!)
                    self.allPokemons.append(pokemon)

                    DispatchQueue.main.async {
                        self.collection.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getPokemonAtIndexPath(_ indexPath: IndexPath) -> PKMPokemon {
        let pokemon: PKMPokemon!
        
        if searchState == .active {
            pokemon = filteredPokemons[indexPath.row]
            
        } else {
            pokemon = allPokemons[indexPath.row]
        }
        
        return pokemon
    }
    
    //Setup cells for usage
    //Dequeue cells that scroll off screen for reuse, else create a new cell to use
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // show only amount that we could see on screen
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PokemonCell {
            let poke = getPokemonAtIndexPath(indexPath)
            cell.configureCell(pokemon: poke)
            
            if let frontSprite = poke.sprites?.frontDefault {
                if let url = URL(string: frontSprite) {
                    do {cell.spriteImage.sd_setImage(with: url, placeholderImage:nil, completed: { (image, error, cacheType, url) -> Void in
                        if (error != nil) {
                            // set placeholder
                            cell.spriteImage.image = self.placeholderImg
                        } else {
                            // set sprite
                            cell.spriteImage.image = image
                        }
                    })}
                }
            }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopUp" {
            if let nextVC = segue.destination as? PopUpViewController {
                let pokemon: PKMPokemon!
                
                guard let cell = (sender as AnyObject).superview?.superview as? PokemonCell else {
                    print("button is not contained in a table view cell")
                    return
                }
                
                guard let indexPath = collection.indexPath(for: cell) else {
                    print("failed to get index path for cell containing button")
                    return
                }
                
                if searchState == .active {
                    pokemon = filteredPokemons[indexPath.row]
                    
                } else {
                    pokemon = allPokemons[indexPath.row]
                }
                
                nextVC.pokemon = pokemon
                print("pokemon sent to vc is:\(pokemon.name ?? "error")")
                /*if let poke = sender as? PKMPokemon {
                    
                    nextVC.pokemon = poke
                }*/
            }
        }
    }
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon: PKMPokemon!
        
        if searchState == .active {
            pokemon = filteredPokemons[indexPath.row]
        } else {
            pokemon = allPokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "toPopUp", sender: pokemon)
        // insert segue code to view detail based on pokemon selected
        // performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }*/

    //Returns how many objects in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchState == .active {
            return filteredPokemons.count
        } else {
            return allPokemons.count
        }
    }
    
    //Returns how many sections in collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //Define size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    //MARK: Searching
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchState = .inactive
            
            view.endEditing(true)
            
        } else {
            searchState = .active
            let lower = searchBar.text!.lowercased()
            
            filteredPokemons = allPokemons.filter({$0.name?.range(of: lower) != nil})
        }
        
        collection.reloadData()
    }
}

