//
//  CountryDetailViewController.swift
//  CountryInfo
//
//  Created by Abhishek on 07/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit
import SVGKit

class CountryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var countryFlagImageView: UIImageView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var saveButton: UIButton?

    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    /// To update the UI,
    func updateUI() {

        self.tableView?.register(UINib.init(nibName: "CountryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryDetailCellIdentifier")

        if !NetworkManager.isNetworkAvailable() {
            self.saveButton?.isHidden = true
        }
        let countryInfo: CountryInfo = CountryListViewModel.sharedInstance.getCountryInfoFor(self.selectedIndex)
        self.title = countryInfo.countryName

        self.countryFlagImageView?.downloadImageFrom(countryInfo.flagImageUrl)

    }
    
    ///  To save the selected country detail.
    ///
    /// - Parameter sender: button object which is pressed
    @IBAction func saveCountryInfo(_ sender: UIButton) {
        let countryInfo: CountryInfo = CountryListViewModel.sharedInstance.getCountryInfoFor(self.selectedIndex)

        if !CountryListViewModel.sharedInstance.isRecordExistFor(countryInfo.countryName) {
            CountryListViewModel.sharedInstance.storeImageInCache(image: (self.countryFlagImageView?.image)!, imageUrl: countryInfo.flagImageUrl)
            
            CountryListViewModel.sharedInstance.saveCountryInfoFor(self.selectedIndex)
            self.showAlertWith(CountryDetailConstant.kSuccessTitle, CountryDetailConstant.kRecordSavedMessage)
        } else {
            self.showAlertWith(CountryDetailConstant.kRecordExistTitle, CountryDetailConstant.kRecordExistMessage)
        }
    }
    
    /// To show alert on saving the data locally.
    func showAlertWith(_ title: String,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)

    }
    // MARK: - Table view Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountryListViewModel.sharedInstance.getSelectedCountryDetailListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailCellIdentifier", for: indexPath) as! CountryDetailTableViewCell
        cell.updateUIfor(indexPath.row)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
