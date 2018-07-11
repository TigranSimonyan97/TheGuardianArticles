//
//  ArticlesListViewController.swift
//  TheGuardianArticles
//
//  Created by Tigran Simonyan on 7/9/18.
//  Copyright © 2018 TigransApps. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController {

    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var refreshControl: UIActivityIndicatorView!
    
    var articles = [ArticleModel]()
    var selectedArticle: ArticleModel!
    
    var articlesImages = [UIImage]()
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureArticlesTableView()
        
        retrieveData()
    }
    
    fileprivate func configureArticlesTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
//        articlesTableView.estimatedRowHeight = 150
//        articlesTableView.rowHeight = UITableView.automaticDimension
        articlesTableView.tableFooterView?.isHidden = true
    }

    fileprivate func retrieveData() {
        NetworkingHelper.instance.retrieveData { (data) in
            self.articles = data?.results ?? []
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
            }
        }
    }

    fileprivate func retrieveArticlesImages() {
        for article in articles {
            if let urlPath = article.fields["thumbnail"] {
                NetworkingHelper.instance.retrieveImage(withURL: URL(string: urlPath)!) { (imageData) in
                    self.articlesImages.append(UIImage(data: imageData)!)
                    DispatchQueue.main.async {
                        self.articlesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    fileprivate func loadMore() {
        if !isLoading {
            isLoading = true
            articlesTableView.tableFooterView?.isHidden = false
            refreshControl.startAnimating()
            NetworkingHelper.instance.retrieveData { (data) in
                self.articles += data?.results ?? []
                
                DispatchQueue.main.async {
                    self.articlesTableView.reloadData()
                    self.isLoading = false
                    self.refreshControl.stopAnimating()
                    self.articlesTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "showArticleDetails" {
            let destination = segue.destination as! ArticleDetailsViewController
            destination.article = self.selectedArticle
        }
    }
}

extension ArticlesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 20.0 {
            loadMore()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.articleTitleLabel.text = articles[indexPath.row].webTitle

        if let urlPath = articles[indexPath.row].fields["thumbnail"] {
            NetworkingHelper.instance.retrieveImage(withURL: URL(string: urlPath)!) { (imageData) in
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? ArticleCell {
                        cell.articlePhotoImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = articles[indexPath.row]
        performSegue(withIdentifier: "showArticleDetails", sender: nil)
    }
}


