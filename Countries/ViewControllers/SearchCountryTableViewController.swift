//
//  SearchCountryTableViewController.swift
//  CountryInfo
//
//  Created by Abhishek on 07/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit

class SearchCountryTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController = UISearchController()
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    /// To add the search bar in the tableview header
    func updateUI() {
        self.title = "Search Page"
        self.tableView?.register(UINib.init(nibName: "CountryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryInfoCellIdentifier")

        self.definesPresentationContext = true

        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search by Country Name"
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            self.tableView.tableFooterView = UIView()
            return controller
        })()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
        self.populateDataInOfflineMode()
    }
    
    /// To populate data in Offline mode.
    func populateDataInOfflineMode() {
        if !NetworkManager.isNetworkAvailable() {
            CountryListViewModel.sharedInstance.updateListInOfflineMode {
                (success) in
                if success {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// SearchBar delegate method to update the search results based on the user input
    ///
    /// - Parameter searchBar: the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchBar.text ?? ""
        if !NetworkManager.isNetworkAvailable() {
            self.updateSearchResultsInOfflineModeFor(searchString)
        } else {
            self.updateSearchResultsInOnlineModeFor(searchString)
        }
    }

    /// UISearchController delegate method to empty the search results when cancel button of UISearchController is clicked
    ///
    /// - Parameter searchController: the search controller
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        
        if !NetworkManager.isNetworkAvailable() {
            self.populateDataInOfflineMode()
            return
        }

        if searchString.count == 0 {
            CountryListViewModel.sharedInstance.sendRequestForCountryList(searchString, completion: {
                (success) in
                SKActivityIndicator.dismiss()
                self.tableView.reloadData()
            })
        }
    }
    
    /// To update search results in Offline mode
    ///
    /// - Parameter searchString: search input
    func updateSearchResultsInOfflineModeFor(_ searchString: String) {
        if searchString.count == 0 {
            self.populateDataInOfflineMode()
        } else {
            CountryListViewModel.sharedInstance.searchOfflineRecordsWith(searchString)
            self.tableView.reloadData()
        }
    }
    
    /// To update search results in Online mode
    ///
    /// - Parameter searchString: search input
    func updateSearchResultsInOnlineModeFor(_ searchString: String) {
        if searchString.count > 0 {
            SKActivityIndicator.show(CountryDetailConstant.kLoading, userInteractionStatus: false)
        }
        CountryListViewModel.sharedInstance.sendRequestForCountryList(searchString, completion: {
            (success) in
            
            SKActivityIndicator.dismiss()
            if CountryListViewModel.sharedInstance.getCountryListCount() == 0 {
                self.showAlertWith(CountryDetailConstant.kNoRecordFound)
            }

            self.tableView.reloadData()
        })
    }
    
    /// To show alert on saving the data locally.
    func showAlertWith(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - Table view Datasource and Delegate Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountryListViewModel.sharedInstance.getCountryListCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryInfoCellIdentifier", for: indexPath) as! CountryInfoTableViewCell
        cell.updateUIfor(indexPath.row)
        return cell

//        let countryInfo: CountryInfo = CountryListViewModel.sharedInstance.getCountryInfoFor(indexPath.row)
//        cell.imageView?.downloadImageFrom(countryInfo.flagImageUrl)
//        cell.textLabel?.text = countryInfo.countryName
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        CountryListViewModel.sharedInstance.updateSelectedCountryDetailFor(index: indexPath.row)

        let countryDetailViewController: CountryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountryDetailViewController") as! CountryDetailViewController
        countryDetailViewController.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(countryDetailViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
