//
//  CountryTableViewCell.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    lazy var viewModel = CountryCellViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func reloadCell(data:CountryInfoModel) {
        viewModel.reload(data: data)
        lblTitle.text          = viewModel.title()
        lblDescription.text    = viewModel.information()
        imageThumbnail.image   = viewModel.showThumbnail(completionHandler: {[weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.imageThumbnail.image = image
                }
            }
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
