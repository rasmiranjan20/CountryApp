//
//  CountryTableViewCell.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var imageThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    var viewModel       : CountryCellViewModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if AppConstraints.IS_STORYBOARD_NOT_REQUIRED {
            designSubView()
        }
        
    }
    
    func designSubView() {
        imageThumbnail  = UIImageView()
        imageThumbnail.contentMode = .scaleAspectFit
        contentView.addSubview(imageThumbnail)
        imageThumbnail.translatesAutoresizingMaskIntoConstraints = false
        imageThumbnail.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        imageThumbnail.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .vertical)
        
        let imageThumbnailTopConstraint       = NSLayoutConstraint(item: imageThumbnail, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 5)
        let imageThumbnailLeadingConstraint   = NSLayoutConstraint(item: imageThumbnail, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 5)
        //        let imageThumbnailTrailingConstraint  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: imageThumbnail, attribute: .trailing, multiplier: 1, constant: 0)
        let imageThumbnailWidthConstraint     = NSLayoutConstraint(item: imageThumbnail, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100)
        let imageThumbnailAspectConstraint    = NSLayoutConstraint(item: imageThumbnail, attribute: .width, relatedBy: .equal, toItem: imageThumbnail, attribute: .height, multiplier: 100/90, constant: 0)
        let imageThumbnailBottomConstraint     = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem:imageThumbnail , attribute: .bottom, multiplier: 1, constant: 5)
        imageThumbnailBottomConstraint.priority = UILayoutPriority(rawValue: 250)
        
        
        
        lblTitle        = UILabel()
        lblTitle.font   = UIFont(name: "HelveticaNeue", size: 15.0)
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode   = .byWordWrapping
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        lblTitle.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
        let lblTitleTopConstraint       = NSLayoutConstraint(item: lblTitle, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 2)
        let lblTitleLeadingConstraint   = NSLayoutConstraint(item: lblTitle, attribute: .leading, relatedBy: .equal, toItem: imageThumbnail, attribute: .trailing, multiplier: 1, constant: 5)
        let lblTitleTrailingConstraint  = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: lblTitle, attribute: .trailing, multiplier: 1, constant: 5)
        
        lblDescription  = UILabel()
        lblDescription.font   = UIFont(name: "HelveticaNeue", size: 13.0)
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode   = .byWordWrapping
        contentView.addSubview(lblDescription)
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        lblDescription.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        lblDescription.setContentHuggingPriority(UILayoutPriority(201), for: .vertical)
        let lblDescriptionTopConstraint       = NSLayoutConstraint(item: lblDescription, attribute: .top, relatedBy: .equal, toItem: lblTitle, attribute: .bottom, multiplier: 1, constant: 5)
        let lblDescriptionLeadingConstraint   = NSLayoutConstraint(item: lblDescription, attribute: .leading, relatedBy: .equal, toItem: lblTitle, attribute: .leading, multiplier: 1, constant: 0)
        let lblDescriptionTrailingConstraint  = NSLayoutConstraint(item: lblDescription, attribute: .trailing, relatedBy: .equal, toItem: lblTitle, attribute: .trailing, multiplier: 1, constant: 0)
        let lblDescriptionBottomConstraint  = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: lblDescription, attribute: .bottom, multiplier: 1, constant: 5)
        
        
        NSLayoutConstraint.activate([imageThumbnailTopConstraint, imageThumbnailLeadingConstraint, imageThumbnailWidthConstraint, imageThumbnailAspectConstraint, imageThumbnailBottomConstraint, lblTitleTopConstraint, lblTitleLeadingConstraint, lblTitleTrailingConstraint, lblDescriptionTopConstraint, lblDescriptionLeadingConstraint, lblDescriptionTrailingConstraint, lblDescriptionBottomConstraint])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
