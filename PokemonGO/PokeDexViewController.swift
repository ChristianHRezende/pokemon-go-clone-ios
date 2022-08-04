//
//  PokeDexViewController.swift
//  PokemonGO
//
//  Created by Christian Rezende on 03/08/22.
//

import UIKit

class PokeDexViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var capturedPokemons:[Pokemon] = []
    var notCapturedPokemons:[Pokemon] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let coreData = CoreDataPokemon()
        
        self.capturedPokemons = coreData.getCapturedPokemons(captured: true)
        self.notCapturedPokemons = coreData.getCapturedPokemons(captured: false)
        print(capturedPokemons.count)
        print(notCapturedPokemons.count)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Captured"
        }else {
            return "Not captured"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0 {
            return self.capturedPokemons.count
        }else {
            return self.notCapturedPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        if indexPath.section == 0 {
            
            pokemon = self.capturedPokemons[indexPath.row]

        }else {
            pokemon = self.notCapturedPokemons[indexPath.row]

        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        cell.textLabel?.text =
        pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.image!)

        return cell
    }
    

    @IBAction func backToMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
