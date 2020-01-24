//
//  PokemonCell.swift
//  MyPokedex
//
//  Created by Sylvia Lam on 1/23/20.
//  Copyright © 2020 Sylvia Lam. All rights reserved.
//

import UIKit
import PokemonAPI

class PokemonCell: UICollectionViewCell {
    @IBOutlet weak var spriteImage: UIImageView!

    var pokemon: PKMPokemon!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: PKMPokemon) {
        self.pokemon = pokemon
    }
}
