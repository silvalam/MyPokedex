//
//  PopUpViewController.swift
//  MyPokedex
//
//  Created by Sylvia Lam on 1/23/20.
//  Copyright © 2020 Sylvia Lam. All rights reserved.
//

import UIKit
import PokemonAPI

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var spriteImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var moveTable: UITableView!
    
    var pokemon: PKMPokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        moveTable.dataSource = self
        moveTable.delegate = self
        moveTable.register(UITableViewCell.self, forCellReuseIdentifier: "move")
        
        updateUI()
    }
    
    func updateUI(){
        nameLabel.text = pokemon.name
        heightLabel.text = "\(String(describing: pokemon.height))"
        weightLabel.text = "\(String(describing: pokemon.weight))"
        idLabel.text = "\(String(describing: pokemon.id))"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pokemon.moves?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "move", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.removeAnimate()
        self.view.removeFromSuperview()
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
}
