//
//  NewsTableViewCell.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import UIKit
import SDWebImage
class NewsTableViewCell: UITableViewCell {
    var article: Articles! {
        didSet {
            setUi(article: article)
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    private func setUi(article:Articles) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        guard let imageString = article.urlToImage , let imageUrl = URL(string: imageString) else {
            return
        }
        thumbImageView.sd_setImage(with: imageUrl)
        
    }

}
