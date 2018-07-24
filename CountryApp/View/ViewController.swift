//
//  ViewController.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 23/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCountryData()
    }

    func fetchCountryData() {
        CountryInfoWebAPI.getCountryInfo(completionHandler: { response in
            print("response ::\(response)")
        })
    }
    
    func reloadData() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

