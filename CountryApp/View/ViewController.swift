//
//  ViewController.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 23/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableCountry: UITableView!
    lazy var viewModel = ViewControllerViewModel(data:(nil, nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableCountry.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
        fetchCountryData()
    }

    func fetchCountryData() {
        CountryInfoWebAPI.getCountryInfo(completionHandler: {[weak self] response in
            switch response {
                case .countryData(let data):
                    self?.reloadData(countryData:data)
                case .failedWithError(error: let error):
                    self?.showFilureMessage(message: error.localizedDescription)
                    self?.reloadData(countryData:(nil, nil))
                case .failedWithMessage(message: let message):
                    self?.showFilureMessage(message: message)
                    self?.reloadData(countryData:(nil, nil))
            }
        })
    }
    
    func reloadData(countryData:CountryInformation) {
        self.viewModel.reloadData(data:countryData)
        DispatchQueue.main.async { [unowned self] in
            self.tableCountry.reloadData()
        }
    }
    
    func showFilureMessage(message:String) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCountry  = tableView.dequeueReusableCell(withIdentifier:"CountryTableViewCell" , for: indexPath) as! CountryTableViewCell
        let country = viewModel.objectForIndex(index: indexPath)
        cellCountry.reloadCell(data: country)
        return cellCountry
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
