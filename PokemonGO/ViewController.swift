//
//  ViewController.swift
//  PokemonGO
//
//  Created by Christian Rezende on 01/08/22.
//

import UIKit
import MapKit
class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    var counter = 0
    var coreDataPokemon:CoreDataPokemon!
    var pokemons:[Pokemon] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // get pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.getPokemons()
        
        // show pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { timer in
            if let coordinates = self.locationManager.location?.coordinate {
                
                // get random pokemon
                let totalPokemons = UInt32( self.pokemons.count)
                let randomIndex = arc4random_uniform(totalPokemons)
                
                let pokemon = self.pokemons[Int(randomIndex)]
                
                // add annotation
                
                // Common Annotation
                // let annotation = MKPointAnnotation()
                
                // Custom Annotation
                let annotation = PokemonAnnotation(coordinates: coordinates,pokemon: pokemon)
            
                annotation.coordinate.latitude += self.generateRandomLatLongDifference()
                annotation.coordinate.longitude += self.generateRandomLatLongDifference()
                self.map.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func generateRandomLatLongDifference()->Double{
        let randomLatLongDifference = (Double(arc4random_uniform(500)) - 250) / 100000.0
        return randomLatLongDifference
    }
    
    fileprivate func centerMapOnUser() {
        if let coordinates = locationManager.location?.coordinate {
            // another way to get center on user
            // problem: consumes internet so we need create a condition
            let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(region, animated: true)
        }
    }
    
    // execute every time annotation or location is added to the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        }else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon

            annotationView.image = UIImage(named: pokemon.image!)
        }
            
        // size of image
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        annotationView.frame = frame
        
        
        
        return annotationView
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        let pokemon = (annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        // check if isn't the user
        if annotation is MKUserLocation {
            return 
        }
        
        // center map on annotation
        if let coordAnnotation = annotation?.coordinate {
            // another way to get center on user
            // problem: consumes internet so we need create a condition
            let region = MKCoordinateRegion.init(center: coordAnnotation, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(region, animated: true)
            
        }
        // wait the center finish
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            // check if user is close of annotation
             if let userCoordinates = self.locationManager.location?.coordinate{
                 let userIsClose = self.map.visibleMapRect.contains(MKMapPoint(userCoordinates))
                 if userIsClose {
                     print("Can capture")
                     self.coreDataPokemon.capturePokemon(pokemon: pokemon)
                     self.map.removeAnnotation(annotation!)

                     self.showAlertCapture(titleAlert: "Congratulations", messageAlert: "You captured the pokemon \(String(describing: pokemon.name))", pokemon)
                     
                 }
                 else{
                     print("Cant capture")
                     self.showAlertCapture(titleAlert: "You can't capture this pokemon", messageAlert: "The pokemon \(String(describing: pokemon.name)) is further from you", pokemon)
                 }
             }
        }
 
    }
    
    func showAlertCapture(titleAlert:String,messageAlert:String,_ pokemon:Pokemon) {
        let alertController = UIAlertController(title: "Congratulations", message: "You captured the pokemon \(String(describing: pokemon.name))", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if counter < 3 {
            centerMapOnUser()
            counter += 1
        }else {
            locationManager.stopUpdatingLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            // show alert
            let alertController = UIAlertController(title: "Location permission", message: "You need allow the location permission to use this app", preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Open configs", style: .default) { UIAlertAction in
                if let configs = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configs as URL)
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true,completion: nil)
        }
    }
    
    
    
    @IBAction func centerMapOnUser(_ sender: Any) {
        centerMapOnUser()
    }
    @IBAction func openPokedex(_ sender: Any) {
    }


}

