//
//  CoreDataPokemon.swift
//  PokemonGO
//
//  Created by Christian Rezende on 02/08/22.
//

import UIKit
import CoreData

class CoreDataPokemon{
    // get context
    func getContext()->NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    // add all pokemons
    func addAllPokemons(){

        let context = self.getContext()
        
     
        self.createPokemon(name: "Bellsprout", image: "bellsprout", captured: false)
        self.createPokemon(name: "Pikachu", image: "pikachu-2", captured: true)
        self.createPokemon(name: "Rattata", image: "rattata", captured: false)
        self.createPokemon(name: "Bullbasaur", image: "bullbasaur", captured: false)
        self.createPokemon(name: "Snorlax", image: "snorlax", captured: false)
        self.createPokemon(name: "Caterpie", image: "caterpie", captured: false)
        self.createPokemon(name: "Meowth", image: "meowth", captured: false)
        self.createPokemon(name: "Squirtle", image: "squirtle", captured: false)
        self.createPokemon(name: "Charmander", image: "charmander", captured: false)
        self.createPokemon(name: "Mew", image: "mew", captured: false)
        self.createPokemon(name: "Psyduck", image: "psyduck", captured: false)
        self.createPokemon(name: "Zubat", image: "zubat", captured: false)
        
        do {
            try context.save()
        } catch let error {
            print("Failed on create pokemons: \(error.localizedDescription)")
        }
    }
    
    
    // create pokemons
    func createPokemon(name:String,image:String,captured:Bool){
        let context = getContext()
        let pokemon = Pokemon(context: context)
        pokemon.name = name
        pokemon.image = image
        pokemon.captured = captured
    }
    
    func capturePokemon(pokemon:Pokemon){
        let context = self.getContext()
        
        pokemon.captured = true
        do {
            try context.save()
        } catch let error {
            print("Failed on capture pokemons: \(error.localizedDescription)")

        }
    }
    
    func getPokemons()->[Pokemon]{
        let context = getContext()
        
        do {
            var pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            if pokemons.count == 0 {
                self.addAllPokemons()
                return self.getPokemons()
            }
            return pokemons
        } catch let error {
            print("Failed on get pokemons: \(error.localizedDescription)")
        }
        return []
    }
    
    func getCapturedPokemons(captured:Bool)->[Pokemon]{
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        print(String(captured))
        request.predicate = NSPredicate(format: "captured = %@",NSNumber(value: captured ))
        
        do {
           let pokemons =  try context.fetch(request) as [Pokemon]
            return pokemons
        } catch  let error {
            print("Failed on get captured pokemons: \(error.localizedDescription)")
        }
        
        return []
    }
}
