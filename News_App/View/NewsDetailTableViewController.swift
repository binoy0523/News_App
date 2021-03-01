//
//  NewsDetailTableViewController.swift
//  News_App
//
//  Created by user on 27/02/21.
//

import UIKit
import SDWebImage

class NewsDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    var viewModel:NewsDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.title = "Details"
    }
    
//    MARK:- Assing values to UI
    func setupUI() {
        
        newsTitleLabel.text = viewModel.newsTitle
        newsDescriptionLabel.text = viewModel.newsDescription
        newsDateLabel.text = viewModel.newsDateText
        guard let image = viewModel.newsImage else { return }
        newsImageView.sd_setImage(with:image)
    }


}
