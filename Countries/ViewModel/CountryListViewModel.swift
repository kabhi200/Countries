//
//  CountryListViewModel.swift
//  CountryInfo
//
//  Created by Abhishek on 07/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit
import CoreData
class CountryListViewModel: NSObject {

    static let sharedInstance = CountryListViewModel()
    private override init() { }
    private var countriesInfoList = [[String: String]]()
    private var selectedCountryDetail = [String: String]()
    private var savedCountryInfo = [CountryDetail]()
    
    let imageCache = NSCache<NSString, AnyObject>()

    // MARK: Country Info Functionality
    
    /// To send request to fetch the country list based on the user input and parse the data and store locally.
    ///
    /// - Parameters:
    ///   - searchString: the search input given by the user
    ///   - completion: return true if the search is successful, else false
    func sendRequestForCountryList(_ searchString:String, completion:@escaping (Bool) -> Void) {
        self.countriesInfoList.removeAll()

        if searchString.count == 0 {
            completion(false)
        }
        if !NetworkManager.isNetworkAvailable() {
            if self.countriesInfoList.count > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
        NetworkHandler.sharedInstance.sendRequestToFetchCountryListFor(searchString) {
            (success, jsonData) in
            
            if success {
                
                for responseDict in jsonData{
                    let dataDict = responseDict as! NSDictionary

                    let flagImageUrl = dataDict["flag"] as? String ?? ""

                    let countryName = dataDict["name"] as? String ?? ""
                    let capitalName = dataDict["capital"] as? String ?? ""

                    let callingCodeList = dataDict["callingCodes"] as! [Any]
                    let callingCode = callingCodeList.first as? String ?? ""

                    let region = dataDict["region"] as? String ?? ""
                    let subRegion = dataDict["subregion"] as? String ?? ""

                    let timeZoneList = dataDict["timezones"] as! [Any]
                    let timeZone = timeZoneList.first as? String ?? ""

                    let currenciesArray = dataDict["currencies"] as! NSArray
                    let currenciesDict = currenciesArray[0] as! NSDictionary
                    let currencies = currenciesDict["name"] as? String ?? ""

                    let languagesArray = dataDict["languages"] as! NSArray
                    let languagesDict = languagesArray[0] as! NSDictionary
                    let languages = languagesDict["name"] as? String ?? ""

                    self.updateCountriesList(flagImageUrl, countryName, capitalName, callingCode, region, subRegion, timeZone, currencies, languages)
                }
                let uniqueOrdered = Array(NSOrderedSet(array: self.countriesInfoList))
                self.countriesInfoList = uniqueOrdered as! [[String: String]]
            }
            completion(success)
        }
    }
    
    /// To save the countries data locally
    ///
    /// - Parameters:
    ///   - flagUrl: the flag image url
    ///   - countryName: the name of the country
    ///   - countryCapitalName: capital name of the country
    ///   - countryCallingCode: calling code of the country
    ///   - countryRegion: region in which the country belong
    ///   - countrySubRegion: subregion of the country
    ///   - countryTimeZone: timezone of the country
    ///   - countryCurrencies: currency of the country
    ///   - countryLanguages: language of the country
    func updateCountriesList(_ flagUrl: String,_ countryName: String?,_ countryCapitalName: String?,_ countryCallingCode: String?,_ countryRegion: String?,_ countrySubRegion: String?,_ countryTimeZone: String?,_ countryCurrencies: String?,_ countryLanguages: String) {
        
        var dict = [String: String]()
        dict[CountryDetailConstant.kFlagImageUrl] = flagUrl
        dict[CountryDetailConstant.kCountryName] = countryName
        dict[CountryDetailConstant.kCountryCapitalName] = countryCapitalName
        dict[CountryDetailConstant.kCountryCallingCode] = countryCallingCode
        dict[CountryDetailConstant.kCountryRegion] = countryRegion
        dict[CountryDetailConstant.kCountrySubRegion] = countrySubRegion
        dict[CountryDetailConstant.kCountryTimeZone] = countryTimeZone
        dict[CountryDetailConstant.kCountryCurrencies] = countryCurrencies
        dict[CountryDetailConstant.kCountryLanguages] = countryLanguages

        self.countriesInfoList.append(dict)
    }
    
    /// To get the number of the country records
    ///
    /// - Returns: count of the country list
    func getCountryListCount() -> Int {
        return self.countriesInfoList.count
    }
    
    /// To get the flage image and country name for the given index of the country list.
    ///
    /// - Parameter index: index of the country list
    /// - Returns: CountryInfo object which is a tuple containing flag image and country name.
    func getCountryInfoFor(_ index: Int) -> CountryInfo {
        let countryInfo: CountryInfo
        countryInfo.flagImageUrl = self.countriesInfoList[index][CountryDetailConstant.kFlagImageUrl]!
        countryInfo.countryName = self.countriesInfoList[index][CountryDetailConstant.kCountryName]!
        return countryInfo
    }
    
    // MARK: Country Detail Functionality

    /// To update the detail of the selected country
    ///
    /// - Parameter index: the index of the selected country
    func updateSelectedCountryDetailFor(index: Int) {
        self.selectedCountryDetail = self.countriesInfoList[index]
    }
    
    /// To get the number of the records in country detail
    ///
    /// - Returns: the count of the records in country detail
    func getSelectedCountryDetailListCount() -> Int {
        return self.selectedCountryDetail.keys.count - 1 //-1 is for flag image url which will not be shown to the user
    }

    /// To get the country detail for the given index
    ///
    /// - Parameter index: the selected country index
    /// - Returns: CountryDetailInfo object which is a tuple containing header and detail info
    func getCountryDetailInfoFor(_ index: Int) -> CountryDetailInfo {
        
        let countryDetailInfo: CountryDetailInfo
        var headerArray = Array(self.selectedCountryDetail.keys).filter {( $0 != CountryDetailConstant.kFlagImageUrl)}
        headerArray.sort()
        countryDetailInfo.headerInfo = headerArray[index]
        countryDetailInfo.detailInfo = self.selectedCountryDetail[headerArray[index]]!
        return countryDetailInfo
    }
    
    // MARK: Offline Data Functionality
    
    /// To save country detail for offline mode
    ///
    /// - Parameter index: the index of the selected country
    func saveCountryInfoFor(_ index: Int) {
        
        let _ : CountryDetail = CountryDetail.init(self.selectedCountryDetail[CountryDetailConstant.kFlagImageUrl]!, self.selectedCountryDetail[CountryDetailConstant.kCountryName]!, self.selectedCountryDetail[CountryDetailConstant.kCountryCapitalName]!, self.selectedCountryDetail[CountryDetailConstant.kCountryCallingCode]!, self.selectedCountryDetail[CountryDetailConstant.kCountryRegion]!, self.selectedCountryDetail[CountryDetailConstant.kCountrySubRegion]!, self.selectedCountryDetail[CountryDetailConstant.kCountryTimeZone]!, self.selectedCountryDetail[CountryDetailConstant.kCountryCurrencies]!, self.selectedCountryDetail[CountryDetailConstant.kCountryLanguages]!)
    }
    
    
    /// To store image in cache on saving any country detail
    ///
    /// - Parameters:
    ///   - image: the image of the country
    ///   - imageUrl: the image url string
    func storeImageInCache(image: UIImage, imageUrl: String) {
        self.imageCache.setObject(image, forKey: imageUrl as NSString)
        
    }

    /// To update the country list in offline mode.
    ///
    /// - Parameter completion: return true if the data is found, else false
    func updateListInOfflineMode(completion:@escaping (Bool) -> Void) {
        self.countriesInfoList.removeAll()
        self.fetchSavedCountryInfoInOfflineMode()
        for countryDetail in self.savedCountryInfo {
            self.updateCountriesList(countryDetail.flagImageUrl!, countryDetail.countryName!, countryDetail.countryCapitalName!, countryDetail.countryCallingCode!, countryDetail.countryRegion!, countryDetail.countrySubRegion!, countryDetail.countryTimeZone!, countryDetail.countryCurrencies!, countryDetail.countryLanguages!)
        }
        
        if self.countriesInfoList.count > 0 {
            completion(true)
        } else {
            completion(false)
        }
    }

    /// To fetch the saved country details
    func fetchSavedCountryInfoInOfflineMode() {
        do {
            self.savedCountryInfo = try CoreDataManager.sharedInstance.context.fetch(CountryDetail.fetchRequest())
        } catch {
            print ("fetch task failed")
        }
    }
    
    func isRecordExistFor(_ countryName: String) -> Bool {
        self.fetchSavedCountryInfoInOfflineMode()
        let records = self.savedCountryInfo.filter{($0.countryName == countryName)}
        if records.count > 0 {
            return true
        }
        return false
    }
    
    /// To search the country from the offline storage based on the user input
    ///
    /// - Parameter searchString: the search input given by the user
    func searchOfflineRecordsWith(_ searchString: String) {
        CountryListViewModel.sharedInstance.updateListInOfflineMode {
            (success) in
            self.countriesInfoList = self.countriesInfoList.filter{(($0[CountryDetailConstant.kCountryName] as! String).contains(searchString))}
        }
    }
}
