//
//  UniversitiesViewController.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import Foundation
import UIKit

class UniversitiesViewController: UITableViewController {
    var isSearch:Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    var country:Country?
    var items = [UniversitiesViewModel]()
    var itemsSearch = [UniversitiesViewModel]()
    lazy var searchBar:UISearchBar = UISearchBar()
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    func setUpSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        self.navigationController?.setNavigationBar()
        self.navigationController?.setCustomBack(imageName: "back", title: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSearchBar()
        if let country = country {
            self.loadUniversities(country: country.country)
        }
        self.title = "Universities"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.isSearch ?  itemsSearch.count :  items.count
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.isSearch ? itemsSearch[indexPath.row] : items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "universityCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "universityCell")
        cell.configure(item)
        return cell
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.isSearch ? itemsSearch[indexPath.row] : items[indexPath.row]
        item.select()
    }
    
    func loadUniversities(country:String) {
        UniversitiesApi.shared.getUniversities(country: country) { [weak self] result  in
            DispatchQueue.main.async {
                self?.handleAPIResult(result.map { items in
                    items.map { item in
                        UniversitiesViewModel(item) {
                            self?.loadURL(url: item.webPages.first ?? "", item:item)
                        }
                    }
                })
            }
        }
    }
    
    private func handleAPIResult(_ result: Result<[UniversitiesViewModel], Error>) {
        switch result{
        
        case .success(let countrys):
            self.items = countrys
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            break
        case .failure(let error):
            self.show(error: error)
            break
        }
    }

}

extension UniversitiesViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            itemsSearch = items.filter{ item in
                item.title.contains(searchText)
            }
            isSearch = true
        } else {
            isSearch = false
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
               searchBar.resignFirstResponder()
               isSearch = false
        }
           
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
               searchBar.resignFirstResponder()
               isSearch = false
        }
           
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
               searchBar.resignFirstResponder()
               isSearch = false
        }
}
