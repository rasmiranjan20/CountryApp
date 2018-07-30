//
//  ViewController.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 23/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit
import MBProgressHUD
class ViewController: UIViewController {

    @IBOutlet var tableCountry: UITableView!
    @IBOutlet var collectionCountry: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    lazy var viewModel = ViewControllerViewModel(data:(nil, nil))
    lazy var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppConstraints.IS_STORYBOARD_NOT_REQUIRED {
            designSubViews()
        }
        validateView()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCountryData()
    }
    
    func designSubViews() {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad :
            flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: 180, height: 180)
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
            collectionCountry   = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
            collectionCountry.backgroundView?.backgroundColor = .white
            collectionCountry.backgroundColor                 = .white
            collectionCountry.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: "CountryCollectionViewCell")
            view.addSubview(collectionCountry)
            
            collectionCountry.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint       = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: collectionCountry, attribute: .top, multiplier: 1, constant: 0)
            let leadingConstraint   = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: collectionCountry, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint  = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: collectionCountry, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint    = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: collectionCountry, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([topConstraint,leadingConstraint, trailingConstraint, bottomConstraint])
        default:
            tableCountry   = UITableView(frame: view.frame, style: .plain)
            tableCountry.tableHeaderView = UIView(frame: .zero)
            tableCountry.tableFooterView = UIView(frame: .zero)
            tableCountry.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryTableViewCell")
            view.addSubview(tableCountry)
            tableCountry.rowHeight          = UITableViewAutomaticDimension
            
            tableCountry.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint       = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: tableCountry, attribute: .top, multiplier: 1, constant: 0)
            let leadingConstraint   = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: tableCountry, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint  = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: tableCountry, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint    = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: tableCountry, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([topConstraint,leadingConstraint, trailingConstraint, bottomConstraint])
        }
    }
    
    func validateView() {
        refreshControl.addTarget(self, action: #selector(reloadRefreshControl(control:)), for: .valueChanged)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad :
            collectionCountry.dataSource        = self
            collectionCountry.delegate          = self
            collectionCountry.addSubview(refreshControl)
            flowLayout.estimatedItemSize        = UICollectionViewFlowLayoutAutomaticSize
            tableCountry?.isHidden              = true
            collectionCountry?.isHidden         = false
        default:
            tableCountry.dataSource             = self
            tableCountry.delegate               = self
            tableCountry.addSubview(refreshControl)
            tableCountry.rowHeight              = UITableViewAutomaticDimension
            tableCountry?.isHidden              = false
            collectionCountry?.isHidden         = true
        }
    }
    
    @objc func reloadRefreshControl(control:UIRefreshControl)  {
        fetchCountryData()
    }
    
    /// Fetch data.
    func fetchCountryData() {
            WebServiceWrapper.shared.checkReachability()
            if WebServiceWrapper.shared.isReachable {
                MBProgressHUD.showAdded(to: view, animated: true)
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
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            self.title = self.viewModel.title
            switch UIDevice.current.userInterfaceIdiom {
            case .pad :
                self.collectionCountry.reloadData()
            default:
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
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
