//
//  CountryCollectionViewCell.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    var viewModel   : CountryCellViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if AppConstraints.IS_STORYBOARD_NOT_REQUIRED {
            designSubView()
        }
    }
    func designSubView() {
        imageThumbnail  = UIImageView()
        imageThumbnail.contentMode = .scaleAspectFit
        contentView.addSubview(imageThumbnail)
        imageThumbnail.translatesAutoresizingMaskIntoConstraints = false
        imageThumbnail.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        imageThumbnail.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let imageThumbnailTopConstraint       = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: imageThumbnail, attribute: .top, multiplier: 1, constant: 0)
        let imageThumbnailLeadingConstraint   = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: imageThumbnail, attribute: .leading, multiplier: 1, constant: 0)
        let imageThumbnailTrailingConstraint  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: imageThumbnail, attribute: .trailing, multiplier: 1, constant: 0)
        let imageThumbnailWidthConstraint     = NSLayoutConstraint(item: imageThumbnail, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 180)
        let imageThumbnailAspectConstraint    = NSLayoutConstraint(item: imageThumbnail, attribute: .width, relatedBy: .equal, toItem: imageThumbnail, attribute: .height, multiplier: 180.0/128.0, constant: 0)
        
        lblTitle        = UILabel()
        lblTitle.font   = UIFont(name: "HelveticaNeue", size: 16.0)
        lblTitle.numberOfLines = 0
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let lblTitleTopConstraint       = NSLayoutConstraint(item: lblTitle, attribute: .top, relatedBy: .equal, toItem: imageThumbnail, attribute: .bottom, multiplier: 1, constant: 2)
        let lblTitleLeadingConstraint   = NSLayoutConstraint(item: lblTitle, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 5)
        let lblTitleTrailingConstraint  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: lblTitle, attribute: .trailing, multiplier: 1, constant: 5)
        
        lblDescription  = UILabel()
        lblDescription.font   = UIFont(name: "HelveticaNeue", size: 14.0)
        lblDescription.numberOfLines = 0
        contentView.addSubview(lblDescription)
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        lblDescription.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let lblDescriptionTopConstraint       = NSLayoutConstraint(item: lblDescription, attribute: .top, relatedBy: .equal, toItem: lblTitle, attribute: .bottom, multiplier: 1, constant: 5)
        let lblDescriptionLeadingConstraint   = NSLayoutConstraint(item: lblDescription, attribute: .leading, relatedBy: .equal, toItem: lblTitle, attribute: .leading, multiplier: 1, constant: 0)
        let lblDescriptionTrailingConstraint  = NSLayoutConstraint(item: lblDescription, attribute: .trailing, relatedBy: .equal, toItem: lblTitle, attribute: .trailing, multiplier: 1, constant: 0)
        let lblDescriptionBottomConstraint  = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: lblDescription, attribute: .bottom, multiplier: 1, constant: 5)
        
        
        NSLayoutConstraint.activate([imageThumbnailTopConstraint, imageThumbnailLeadingConstraint, imageThumbnailTrailingConstraint, imageThumbnailWidthConstraint, imageThumbnailAspectConstraint, lblTitleTopConstraint, lblTitleLeadingConstraint, lblTitleTrailingConstraint, lblDescriptionTopConstraint, lblDescriptionLeadingConstraint, lblDescriptionTrailingConstraint, lblDescriptionBottomConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadCell(data:CountryInfoModel) {
        viewModel = CountryCellViewModel(load: data)
        
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
}


