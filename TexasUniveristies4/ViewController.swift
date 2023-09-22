//
//  ViewController.swift
//  TexasUniveristies4
//
//  Created by Crystal Ottih on 4/30/23.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var UniTable: UITableView!
    
    
    var selectedUniversity: University?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            UniTable.dataSource = self
            UniTable.delegate = self
            UniTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            let initialLocation = CLLocationCoordinate2D(latitude: 30.2849185, longitude: -97.7340567)
            let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
            
            for university in universities {
                let annotation = MKPointAnnotation()
                annotation.coordinate = university.coordinate
                annotation.title = university.name
                annotation.subtitle = university.address
                mapView.addAnnotation(annotation)
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return universities.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let university = universities[indexPath.row]
            cell.textLabel?.text = university.name
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUniversity = universities[indexPath.row]
        showMapViewController()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func showMapViewController() {
        guard let selectedUniversity = selectedUniversity else { return }
        let mapViewController = MapViewController()
        mapViewController.university = selectedUniversity
        mapViewController.mapView = mapView
        mapViewController.modalPresentationStyle = .fullScreen
        present(mapViewController, animated: true, completion: nil)
    }

        
    }

    struct University {
        let name: String
        let address: String
        let coordinate: CLLocationCoordinate2D
    }

let universities = [
    University(name: "University of Texas at Austin", address: "Austin, TX", coordinate: CLLocationCoordinate2D(latitude: 30.2849185, longitude: -97.7340567)),
    University(name: "Texas A&M University", address: "College Station, TX", coordinate: CLLocationCoordinate2D(latitude: 30.6134788, longitude: -96.341553)),
    University(name: "University of Houston", address: "Houston, TX", coordinate: CLLocationCoordinate2D(latitude: 29.7210607, longitude: -95.3411525)),
    University(name: "Texas Tech University", address: "Lubbock, TX", coordinate: CLLocationCoordinate2D(latitude: 33.5848374, longitude: -101.8747771)),
    University(name: "Baylor University", address: "Waco, TX", coordinate: CLLocationCoordinate2D(latitude: 31.5487445, longitude: -97.1130805)),
    University(name: "Southern Methodist University", address: "Dallas, TX", coordinate: CLLocationCoordinate2D(latitude: 32.8417165, longitude: -96.7843521)),
    University(name: "University of North Texas", address: "Denton, TX", coordinate: CLLocationCoordinate2D(latitude: 33.2116627, longitude: -97.1496406)),
    University(name: "University of Texas at Arlington", address: "Arlington, TX", coordinate: CLLocationCoordinate2D(latitude: 32.7298797, longitude: -97.1155541)),
    University(name: "Texas State University", address: "San Marcos, TX", coordinate: CLLocationCoordinate2D(latitude: 29.8889945, longitude: -97.9383948)),
    University(name: "University of Texas at Dallas", address: "Richardson, TX", coordinate: CLLocationCoordinate2D(latitude: 32.9857609, longitude: -96.7500993))
]

class CustomViewController: UIViewController, UITextFieldDelegate {

    let inputTextField = UITextField()

    override var inputAccessoryView: UIView? {
        return createInputAccessoryView()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = "Tap here to activate keyboard"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTextField)

        NSLayoutConstraint.activate([
            inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputTextField.widthAnchor.constraint(equalToConstant: 200),
            inputTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func createInputAccessoryView() -> UIView {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))

        toolbar.setItems([flexibleSpace, backButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        return toolbar
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        becomeFirstResponder()
    }
}


class MapViewController: CustomViewController, MKMapViewDelegate {

    var university: University?
    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        if let university = university {
            mapView = MKMapView(frame: view.bounds)
            mapView.delegate = self
            view.addSubview(mapView)

            let annotation = MKPointAnnotation()
            annotation.coordinate = university.coordinate
            annotation.title = university.name
            annotation.subtitle = university.address
            mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(center: university.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
        } else {
            print("University is nil")
        }
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc override func backButtonPressed() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "UniversityAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
