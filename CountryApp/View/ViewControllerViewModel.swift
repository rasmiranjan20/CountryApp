//
//  ViewControllerViewModel.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class ViewControllerViewModel: NSObject {
   lazy var title = ""
   lazy var countryInfo = [CountryInfoModel]()

    required init(data:CountryInformation) {
        super.init()
        self.title = data.title ?? ""
        self.countryInfo = data.info ?? []
    }
    
    func reloadData(data:CountryInformation) {
        self.title = data.title ?? ""
        self.countryInfo = data.info ?? []
    }
    
    func numberOfRow() -> Int {
            return countryInfo.count
    }
    func objectForIndex(index:IndexPath) -> CountryInfoModel {
        return countryInfo[index.row]
    }
    
    }
