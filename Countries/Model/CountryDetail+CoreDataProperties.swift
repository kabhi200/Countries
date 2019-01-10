//
//  CountryDetail+CoreDataProperties.swift
//  CountryInfo
//
//  Created by Abhishek on 07/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//
//

import Foundation
import CoreData


extension CountryDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryDetail> {
        return NSFetchRequest<CountryDetail>(entityName: "CountryDetail")
    }

    @NSManaged public var flagImageUrl: String?
    @NSManaged public var countryName: String?
    @NSManaged public var countryCapitalName: String?
    @NSManaged public var countryCallingCode: String?
    @NSManaged public var countryRegion: String?
    @NSManaged public var countrySubRegion: String?
    @NSManaged public var countryTimeZone: String?
    @NSManaged public var countryCurrencies: String?
    @NSManaged public var countryLanguages: String?

    /// Init object to store the country detail.
    convenience init(_ flagUrl: String,_ countryName: String?,_ countryCapitalName: String?,_ countryCallingCode: String?,_ countryRegion: String?,_ countrySubRegion: String?,_ countryTimeZone: String?,_ countryCurrencies: String?,_ countryLanguages: String) {
        
        self.init(context: CoreDataManager.sharedInstance.context)
        self.countryName = countryName
        self.countryCapitalName = countryCapitalName
        self.countryCallingCode = countryCallingCode
        self.countryRegion = countryRegion
        self.countrySubRegion = countrySubRegion
        self.countryTimeZone = countryTimeZone
        self.countryCurrencies = countryCurrencies
        self.countryLanguages = countryLanguages
        self.flagImageUrl = flagUrl
        CoreDataManager.sharedInstance.saveContext()
    }

}
