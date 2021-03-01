//
//  ViewController.swift
//  News_App
//
//  Created by user on 25/02/21.
//

import UIKit
import RxCocoa
import RxSwift


class HomeViewController: UIViewController, HomeViewViewProtocol {
    
    var transitionThumbnail: UIImageView?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCell : NewsTableViewCell!
    private let bag = DisposeBag()
    private var viewModel : HomeListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = HomeListViewModel(withViewDelegate: self)
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        tableView.rx.setDelegate(self).disposed(by: bag)
        self.bindViews()
        self.title = "News"
        
    }
    
    private func bindViews() {
        
//        TableView Binding
        viewModel.articles
            .bind(to: tableView.rx.items(cellIdentifier: "NewsTableViewCell", cellType: NewsTableViewCell.self)) { (row,item,cell) in
                cell.article = item
                
            }.disposed(by: bag)
        
        
//        Did select item & model binding
        tableView.rx
            .modelSelected(Articles.self).subscribe(onNext: { [weak self] article in
                self?.viewModel.didSelectArticle(article: article)
            }).disposed(by: bag)
        
        tableView.rx
            .itemSelected.subscribe(onNext: { [weak self] indexPath in
                let cell = self?.tableView.cellForRow(at: indexPath) as? NewsTableViewCell
                cell?.setSelected(false, animated: true)
            }).disposed(by: bag)
        
        
//        Search Bar Binding
        
        searchBar.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchObserver)
            .disposed(by: bag)
 
//        viewModel.fetchNews()
        
    }
    
    
    // ViewProtocol selction Implementation
    func selectedNewsWith(vm: NewsDetailViewModelProtocol) {
        
        guard let detailVc = self.storyboard?.instantiateViewController(identifier: "NewsDetailTableViewController") as? NewsDetailTableViewController else { return }
        detailVc.viewModel = vm
        self.navigationController?.pushViewController(detailVc, animated: true)
        
        
    }
}

// MARK:- UITableView Delegate

extension HomeViewController: UITableViewDelegate, UIScrollViewDelegate  {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        //Bottom Refresh

        if scrollView == tableView{

            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                self.viewModel.fetchMoreNews()
            }
        }
    }
    
}

