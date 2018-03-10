//
//  NurseTrackViewController.swift
//  QuickHealthDoctorApp
//
//  Created by SS042 on 23/01/18.
//  Copyright © 2018 SS142. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class NurseTrackViewController: UIViewController{

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var trackUserView: UIView!
    @IBOutlet var mapView: GMSMapView!
    var trackNurseView:TrackNurseView!
    var trackUserData:TrackNurse!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var polyline:GMSPolyline!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackUserView.addSubview(self.getTrackNurseHeaderView())
        self.trackUserData = TrackNurse()
        trackNurseView.userTrackData = self.trackUserData
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        //mapview customization
        self.mapView.isMyLocationEnabled = true
        self.mapView.tintColor = UIColor.red
        
        self.setDestinationMarkerAndAnotation()
    }
    
    func setDestinationMarkerAndAnotation(){
        let london = GMSMarker(position: self.trackUserData.cordinates)
        london.title = self.trackUserData.address
        london.map = mapView
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTrackNurseHeaderView()->TrackNurseView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TrackNurseView", bundle: bundle)
        trackNurseView = nib.instantiate(withOwner: self, options: nil)[0] as! TrackNurseView
        
        return trackNurseView
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

extension NurseTrackViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
            if self.mapView.myLocation != nil{
                self.getPolylineRoute(from: (self.mapView.myLocation?.coordinate)!, to: self.trackUserData.cordinates)
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

    //Fetch route in google map
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyBBVXutvuWZ9s2Y42Q__PnWvx5JPmxdWzw")!
        print(url)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                            }
                            return
                        }
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            
                            DispatchQueue.main.async {
                                self.showPath(polyStr: points!)
                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                self.mapView!.moveCamera(update)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.removePatFromMap()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        self.removePatFromMap()
                    }
                }
            }
        })
        task.resume()
    }
    
    //Draw route in google map
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        if polyline.map != nil{
            polyline.map = nil
        }
        polyline.map = mapView // Your map view
    }
    
    func removePatFromMap(){
        if polyline != nil && polyline.map != nil{
            polyline.map = nil
        }
    }
    
}
