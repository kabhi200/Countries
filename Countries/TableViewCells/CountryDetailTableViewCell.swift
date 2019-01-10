//
//  CountryDetailTableViewCell.swift
//  CountryInfo
//
//  Created by Abhishek on 09/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerInfoLabel: UILabel?
    @IBOutlet weak var detailInfoLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// To update the header and detail info.
    ///
    /// - Parameter index: selected country index
    func updateUIfor(_ index: Int) {
        
        let countryDetailInfo: CountryDetailInfo = CountryListViewModel.sharedInstance.getCountryDetailInfoFor(index)
        self.headerInfoLabel?.text = countryDetailInfo.headerInfo
        self.detailInfoLabel?.text = countryDetailInfo.detailInfo
    }
    
}
