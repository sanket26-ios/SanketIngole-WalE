//
//  Constants.swift
//  WalE
//
//  Created by sanket ingole on 01/12/21.
//

import Foundation

let apiKey = "B0CMhaR93ihLDa26Lvnptrk6vxB1dr0G9l398rEU"
let baseUrl = "https://api.nasa.gov/"

let planetoryUrl = baseUrl + "planetary/apod?api_key=" + apiKey
let JsonUserDefaultKey = "jsonUserDefaultKey"

let NoDataErrorMsg = "Please check your internet connection"
let OldDataErrorMessage = "Due To some issue we are loading old data"

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT-8")
        return dateFormatter.string(from: Date())
        
    }
}
