//
//  ViewCell.swift
//  MVVM-TableView
//
//  Created by 光光 on 7/24/19.
//  Copyright © 2019 feilei. All rights reserved.
//

import UIKit
import SDWebImage
class ViewCell: UITableViewCell {

    @IBOutlet weak var bkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var config: CellViewModel? {
        didSet {
            titleLabel.text = config?.titleText
            descriptionLabel.text = config?.descText
            dateLabel.text = config?.dateText
            bkImage.sd_setImage(with: URL( string: config?.imageUrl ?? ""), completed: nil)

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
