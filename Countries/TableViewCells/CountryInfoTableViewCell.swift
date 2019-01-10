//
//  CountryInfoTableViewCell.swift
//  CountryInfo
//
//  Created by Abhishek on 08/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit

class CountryInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel?
    @IBOutlet weak var flagImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// To update the header and detail info.
    ///
    /// - Parameter index: selected country index
    func updateUIfor(_ index: Int) {
        let countryInfo: CountryInfo = CountryListViewModel.sharedInstance.getCountryInfoFor(index)
        self.countryNameLabel?.text = countryInfo.countryName
        self.flagImageView?.downloadImageFrom(countryInfo.flagImageUrl)
    }
    
}
