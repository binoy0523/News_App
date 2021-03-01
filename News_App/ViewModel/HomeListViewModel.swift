//
//  HomeListViewModel.swift
//  News_App
//
//  Created by user on 26/02/21.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeListViewModelProtocol {
    
    var model:NewsListModelProtocol {get set}
    
    var articles:Observable<[Articles]> {get set}
    
    var searchObserver: AnyObserver<String> {get set}
    
    var viewDelegate:HomeViewViewProtocol? {get set}
    
    
    func fetchNews()
    
    func didSelectArticle(article:Articles)
    
    func fetchMoreNews()
    
    func searchNewsFor(query:String)
}


class HomeListViewModel:HomeListViewModelProtocol {
    
    var articles: Observable<[Articles]>
    
    var searchObserver: AnyObserver<String>
    
    var currentPageIndex = 1
    
    var model: NewsListModelProtocol
    
    var viewDelegate: HomeViewViewProtocol?
    
    private let disposeBag = DisposeBag()
    private var articlesSubject = BehaviorRelay<[Articles]>(value: [])
    private var searchSubject = PublishSubject<String>()
    
    
    init(withViewDelegate viewDelegate:HomeViewViewProtocol? = nil, withModel model:NewsListModelProtocol = NewsListModel() ) {
        articles = articlesSubject.asObservable()
        searchObserver = searchSubject.asObserver()
        self.model = model
        self.viewDelegate = viewDelegate
        self.bindSearch()
    }
    
    //    Observing Search
    func bindSearch() {
        searchSubject
            .asObservable()
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                if query.isEmpty {
                    self.fetchNews()
                } else {
                    self.searchNewsFor(query: query)
                }
                
                
            }).disposed(by: disposeBag)
    }
    
    //  MARK:- Implementation for News Selection
    func didSelectArticle(article: Articles) {
        let model = NewsDetailModel(article: article)
        let newsDetailVm = NewsDetailViewModel(model: model)
        self.viewDelegate?.selectedNewsWith(vm: newsDetailVm)
        
    }
    
    //  MARK:- Search News for Query
    func searchNewsFor(query:String)  {
        model.searchForNewsWithKey(key: query).subscribe { [unowned self] (articleslist) in
            self.articlesSubject.accept(articleslist)
        } onError: { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    //    MARK:- Fetch Initial News
    func fetchNews() {
        self.fetchNewsAt().subscribe { [unowned self] (articleslist) in
            self.articlesSubject.accept(articleslist)
        } onError: { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    //  MARK:- Fetch News with Page Index
    private  func fetchNewsAt(pageIndex:Int = 1)-> Single<[Articles]> {
        
        return model.fetchNewsForPage(index:pageIndex)
        
    }
    
    //    MARK:- Fetch More News
    func fetchMoreNews() {
        guard  let totalCount = model.totalCount else { return }
        if self.articlesSubject.value.count < totalCount {
            self.currentPageIndex += 1
            self.fetchNewsAt(pageIndex: currentPageIndex).subscribe { [unowned self] (articleslist) in
                
                self.articlesSubject.accept((self.articlesSubject.value) + articleslist)
            } onError: { (error) in
                print(error)
            }.disposed(by: disposeBag)
        }
    }
    
    
}
