//
//  UniverView.swift
//  TexasUniveristies4
//
//  Created by Crystal Ottih on 5/01/23.
//

import Foundation
import UIKit
import MapKit

class UniversityTableController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var universities: [University] = []
    var filteredUniversities: [University] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        // Load universities data
        universities = loadUniversities()
        filteredUniversities = universities
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUniversities = universities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUniversities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let university = filteredUniversities[indexPath.row]
        cell.textLabel?.text = university.name
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let university = filteredUniversities[indexPath.row]
        let universityDetail = UniversityDetail(name: university.name, address: university.address, coordinate: university.coordinate)
        let detailViewController = UniversityDetailController(university: universityDetail)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
    func loadUniversities() -> [University] {
        let universities = [
            University(name: "University of Texas at Austin", address: "Austin, TX", coordinate: CLLocationCoordinate2D(latitude: 30.2861, longitude: -97.7394)),
            University(name: "Texas A&M University", address: "College Station, TX", coordinate: CLLocationCoordinate2D(latitude: 30.6137, longitude: -96.3413)),
            University(name: "University of Houston", address: "Houston, TX", coordinate: CLLocationCoordinate2D(latitude: 29.7199, longitude: -95.3422)),
            University(name: "Texas Tech University", address: "Lubbock, TX", coordinate: CLLocationCoordinate2D(latitude: 33.5849, longitude: -101.8780)),
            University(name: "Baylor University", address: "Waco, TX", coordinate: CLLocationCoordinate2D(latitude: 31.5497, longitude: -97.1143)),
            University(name: "Southern Methodist University", address: "Dallas, TX", coordinate: CLLocationCoordinate2D(latitude: 32.8450, longitude: -96.7842)),
            University(name: "University of North Texas", address: "Denton, TX", coordinate: CLLocationCoordinate2D(latitude: 33.2148, longitude: -97.1331)),
            University(name: "University of Texas at Arlington", address: "Arlington, TX", coordinate: CLLocationCoordinate2D(latitude: 32.7299, longitude: -97.1141)),
            University(name: "Texas State University", address: "San Marcos, TX", coordinate: CLLocationCoordinate2D(latitude: 29.8889, longitude: -97.9380)),
            University(name: "University of Texas at Dallas", address: "Richardson, TX", coordinate: CLLocationCoordinate2D(latitude: 32.9856, longitude: -96.7501))
        ]
        
        return universities
    }
}
