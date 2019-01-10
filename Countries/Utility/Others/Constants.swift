//
//  Constants.swift
//  CountryInfo
//
//  Created by Abhishek on 08/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit

// Tuple Objects
typealias CountryInfo = (flagImageUrl: String, countryName: String)
typealias CountryDetailInfo = (headerInfo: String, detailInfo: String)

//typealias CountryDetailInfo = (flagImageUrl: String, countryName: String, countryCapitalName: String, countryCallingCode: String, countryRegion: String, countrySubRegion: String, countryTimeZone: String, countryCurrencies: String, countryLanguages: String)

let countryListUrl = "https://restcountries.eu/rest/v2/name/"

struct CountryDetailConstant {
    static let kFlagImageUrl = "flagImageUrl"
    static let kCountryName = "Name"
    static let kCountryCapitalName = "Capital"
    
    static let kCountryCallingCode = "Calling Code"
    static let kCountryRegion = "Region"
    static let kCountrySubRegion = "Sub Region"
    static let kCountryTimeZone = "TimeZone"
    
    static let kCountryCurrencies = "Currency"
    static let kCountryLanguages =  "Language"
    
    static let kSuccessTitle =  "Success"
    static let kRecordExistTitle =  "Record Exist"

    static let kRecordSavedMessage =  "Country detail saved successfully"
    static let kRecordExistMessage =  "Record already saved"
    
    static let kNoRecordFound =  "No record found"
    static let kLoading = "LOADING..."

}
