//
//  CountrysViewController.swift
//  UniversitiesGlobal
//
//  Created by Abhisek Ghosh on 24/09/22.
//

import UIKit
import SafariServices

class CountrysViewController: UITableViewController {
    var isSearch:Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    var items = [CountryViewModel]()
    var itemsSearch = [CountryViewModel]()
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
        self.title = "Countries"
        loadCountry()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
        cell.configure(item)
        
        return cell
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.isSearch ? itemsSearch[indexPath.row] : items[indexPath.row]
        item.select()
    }
    func loadCountry() {
        CountrysAPI.shared.getCountryList { [weak self] result in
            DispatchQueue.main.async {
                self?.handleAPIResult(result.map { items in
                    items.map { item in
                        CountryViewModel(item) {
                            self?.select(country: item)
                        }
                    }
                })
            }
        }
    }
    
    private func handleAPIResult(_ result: Result<[CountryViewModel], Error>) {
        switch result{
        
        case .success(let countrys):
            self.items = countrys
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            break
        case .failure(let error):
            show(error: error)
            break
        }
    }

}

extension UINavigationController {
    func setCustomBack(imageName:String, title:String) {
        let yourBackImage = UIImage(named: imageName)
        self.navigationBar.backIndicatorImage = yourBackImage
        self.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationBar.backItem?.title = title
        self.navigationBar.topItem?.title = title
    }
    func setNavigationBar() {
//        searchController.hidesNavigationBarDuringPresentation = true
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.sizeToFit()
    }
}
extension CountrysViewController:UISearchBarDelegate {
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



extension UITableViewCell {
    func configure(_ item: CountryViewModel) {
        textLabel?.text = item.title
    }
    
    func configure(_ item: UniversitiesViewModel) {
        textLabel?.text = item.title
    }
}

extension UIViewController : SFSafariViewControllerDelegate {
    func select(country:Country) {
        let vc = UniversitiesViewController()
        vc.country = country
        show(vc, sender: self)
    }
    func loadURL(url:String, item:CollegeElement) {
        if let url = URL(string: url) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = CustomWebController(url: url, configuration: config)
        vc.element = item
        vc.delegate = self
        show(vc, sender: self)
        } else {
            show(error:CustomError.invalidURL )
        }
    }
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.showDetailViewController(alert, sender: self)
    }
    
}

enum CustomError: Error {
    // Throw when an invalid password is entered
    case invalidURL

    // Throw when an expected resource is not found
    case notFound

    // Throw in all other cases
    case unexpected(code: Int)
}

// For each error type return the appropriate localized description
extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString(
                "The provided url is not valid.",
                comment: "Invalid url"
            )
        case .notFound:
            return NSLocalizedString(
                "The specified item could not be found.",
                comment: "Resource Not Found"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}
