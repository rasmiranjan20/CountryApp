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
    @IBOutlet weak var collectionCountry: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    lazy var viewModel = ViewControllerViewModel(data:(nil, nil))
    lazy var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        validateView()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCountryData()
    }
    
    func validateView() {
        refreshControl.addTarget(self, action: #selector(reloadRefreshControl(control:)), for: .valueChanged)
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionCountry.dataSource    = self
            collectionCountry.delegate      = self
            collectionCountry.addSubview(refreshControl)
            flowLayout.estimatedItemSize    = UICollectionViewFlowLayoutAutomaticSize
            tableCountry.isHidden           = true
            collectionCountry.isHidden      = false
        } else {
            tableCountry.dataSource         = self
            tableCountry.delegate           = self
            tableCountry.tableHeaderView    = refreshControl
            tableCountry.rowHeight          = UITableViewAutomaticDimension
            tableCountry.isHidden           = false
            collectionCountry.isHidden      = true
        }
    }
    
    @objc func reloadRefreshControl(control:UIRefreshControl)  {
        fetchCountryData()
    }
    
    /// Fetch data.
    func fetchCountryData() {
            WebServiceWrapper.shared.checkReachability()
            if WebServiceWrapper.shared.isReachable {
                 CountryInfoWebAPI.getCountryInfo(completionHandler: {[weak self] response in
                    switch response {
                        case .countryData(let data):
                            self?.reloadData(countryData:data)
                        case .failedWithError(error: let error):
                            self?.showFilureMessage(title:"Sorry!", message: error.localizedDescription)
                            self?.reloadData(countryData:(nil, nil))
                        case .failedWithMessage(message: let message):
                            self?.showFilureMessage(title:"Sorry!", message: message)
                            self?.reloadData(countryData:(nil, nil))
                    }
                })
            } else {
                showFilureMessage(title: "Sorry!", message: "Please check the internet connection.")
            }
        WebServiceWrapper.shared.stopNetworkChecking()
    }
    
    func reloadData(countryData:CountryInformation) {
        self.viewModel.reloadData(data:countryData)
        DispatchQueue.main.async { [unowned self] in
            self.refreshControl.endRefreshing()
            self.title = self.viewModel.title
            if UIDevice.current.userInterfaceIdiom == .pad {
                    self.collectionCountry.reloadData()
                } else {
                    self.tableCountry.reloadData()
             }
        }
    }
    
    func showFilureMessage(title:String, message:String) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - For iPhone screen design
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

// MARK: - For iPad design
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellCountry  = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCollectionViewCell", for: indexPath) as! CountryCollectionViewCell
        let country = viewModel.objectForIndex(index: indexPath)
        cellCountry.reloadCell(data: country)
        return cellCountry
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
}
