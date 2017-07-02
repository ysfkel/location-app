//
//  RiderViewController.swift
//  MyInstagram
//
//  Created by Yusuf Kelo on 6/30/17.
//  Copyright © 2017 Yusuf Kelo. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RiderViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0, longitude:0)
    
    
    

    @IBOutlet var map_outlet: MKMapView!
    
    @IBOutlet weak var btnCallUber: UIButton!
    
    var isRiderRequestActive = true
    
    private func toggleRequestButton(_ requestActive:Bool,_ text:String){
      self.btnCallUber.setTitle(text, for:[])
      isRiderRequestActive=requestActive
    }
    
    
  
    
    @IBAction func btnCallUberClick(_ sender: Any) {
        
        
        
        if isRiderRequestActive{
            //if there is active request, cancel the request
             self.toggleRequestButton(false,"Call Uber")
            
        }else{
            
        //if there is no active request,send request
        if userLocation.latitude != 0 && userLocation.longitude != 0{
            self.toggleRequestButton(true,"Cancel Request")
            
            let riderRequest = PFObject(className:"RiderRequest")
            riderRequest["username"] = PFUser.current()?.username;
            
            //riderRequest["location"] = userLocation

            //because this is a parse location , we create a parse geo point
            riderRequest["location"] = PFGeoPoint(latitude:userLocation.latitude, longitude:userLocation.longitude)
            
            riderRequest.saveInBackground(block: {(success, error ) in
            
                if error != nil{
                    print(error!)
                          self.toggleRequestButton(false,"Call Uber")
                    self.createAlert(title:"Request Failure", message: "Could not send location")
                }
                if success{
                  
                    print("success")
                    
                }
            
            
            })
        }else{
                 self.createAlert(title:"Request Failure", message: "cannot detect your location")
        }
            
        }
        
      
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLogin_segue" {
            
            PFUser.logOut()
           // PFUser.current()?.sessionToken?.removeAll()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLocationManager();

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setUpLocationManager(){
         locationManager.delegate =  self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.startUpdatingLocation()
    
    }
    
    func createAlert(title:String,message:String){
        let  alert = UIAlertController(title:title,message:message,preferredStyle:UIAlertControllerStyle.alert);
        
        alert.addAction(UIAlertAction(title:"Ok",style:.default,handler:{(action) in
            
            self.dismiss(animated: true, completion: nil);
            
        }));
        
        self.present(alert,animated:true,completion:nil);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location?.coordinate{
            
            
             userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude:location.longitude);
            
            let region = MKCoordinateRegion(center:userLocation, span:MKCoordinateSpan(latitudeDelta:1.01,longitudeDelta:0.01))
            
            self.map_outlet.setRegion(region, animated:true);
            
            
           //set annotations
            self.map_outlet.removeAnnotations(self.map_outlet.annotations);
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = userLocation
            
            annotation.title = "Your location"
            
            self.map_outlet.addAnnotation(annotation)
            
        
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
