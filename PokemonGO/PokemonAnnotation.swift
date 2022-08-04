//
//  PokemonAnnotation.swift
//  PokemonGO
//
//  Created by Christian Rezende on 03/08/22.
//

import UIKit
import MapKit

// Custom annotation
// Heritage of MKAnnotation because we need a new informantion inside of annotation
// so we gonna extend the class MKAnnotation and add pokemon attribute
class PokemonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var pokemon:Pokemon
    
    init(coordinates:CLLocationCoordinate2D,pokemon:Pokemon){
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
}
