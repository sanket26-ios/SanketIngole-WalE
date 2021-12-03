//
//  ViewModel.swift
//  WalE
//
//  Created by sanket ingole on 01/12/21.
//

import Foundation
import UIKit

protocol WalEMainControllerDelegate : AnyObject {
    func loadImageFromData(image : UIImage?)
    func loadJsonData()
    func dataLoadingErrorWith(msg : String)
}

class ViewModel {
    weak var delegate : WalEMainControllerDelegate?
    var dataObject : WalEDataObject? {
        didSet {
            delegate?.loadJsonData()
            getImageFromUrl()
        }
    }
    
    func getNasaData() {
        if let data = getUserDefaultDataAndComapir() {
            dataObject = data
        } else {
            apiCallForData()
        }
    }
    
    func apiCallForData() {
        guard let request = APIManager.prepareRequest(path: planetoryUrl) else {
            print("url Error")
            return
        }
        APIManager.getResponse(request: request, responseType: WalEDataObject.self) { [weak self] model, error in
            if error != nil {
                self?.loadOldDataDueToSomeError()
            } else {
                self?.dataObject = model
                self?.storeInUsserDefaults()
            }
        }
    }
    
    func storeInUsserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataObject) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: JsonUserDefaultKey)
        }
    }
    
    func getDataFromUserDefaults() -> WalEDataObject? {
        if let data = UserDefaults.standard.object(forKey: JsonUserDefaultKey) as? Data {
            let decoder = JSONDecoder()
            if let nasaData = try? decoder.decode(WalEDataObject.self, from: data) {
                return nasaData
            }
        }
        return nil
    }
    
    func getUserDefaultDataAndComapir() -> WalEDataObject? {
        let data = getDataFromUserDefaults()
        if data?.date == Date.getCurrentDate() {
            return data
        } else {
            return nil
        }
    }
    
    func getImageFromUrl() {
        if let data = getImageDataFromUserDefaults() {
            let image = UIImage.init(data: data)
            delegate?.loadImageFromData(image: image)
        } else {
            downloadImgeFromUrl()
        }
    }
    
    func downloadImgeFromUrl() {
        guard let url = URL.init(string: dataObject?.hdurl ?? "") else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            if let imageData = data {
                let image = UIImage.init(data: imageData)
                self?.delegate?.loadImageFromData(image: image)
                self?.storeImageInUserDefaults(data: imageData)
            } else {
                print("Image Download error")
            }
        }.resume()
    }
    
    func storeImageInUserDefaults(data: Data) {
        if let key = dataObject?.hdurl {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: key)
        }
    }
    
    func getImageDataFromUserDefaults() -> Data? {
        if let key = dataObject?.hdurl, let data = UserDefaults.standard.object(forKey: key) as? Data {
            return data
        } else {
            downloadImgeFromUrl()
            return nil
        }
    }
    
    func loadOldDataDueToSomeError() {
        if let data = self.getDataFromUserDefaults() {
            dataObject = data
            delegate?.dataLoadingErrorWith(msg: OldDataErrorMessage)
        } else {
            delegate?.dataLoadingErrorWith(msg: NoDataErrorMsg)
        }
    }
    
}
