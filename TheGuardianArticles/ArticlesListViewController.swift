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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureArticlesTableView()
        
        retrieveData()
    }
    
    fileprivate func configureArticlesTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.estimatedRowHeight = 50
        articlesTableView.rowHeight = UITableView.automaticDimension
        articlesTableView.tableFooterView?.isHidden = true
    }

    fileprivate func retrieveData() {
        NetworkingHelper.instance.retrieveData { (data) in
            self.articles = data.results
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
            }
            print("articles: \(self.articles)")
        }
    }

}

extension ArticlesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.articleTitleLabel.text = articles[indexPath.row].webTitle
        
        NetworkingHelper.instance.retrieveImage(withURL: URL(string: articles[indexPath.row].fields["thumbnail"]!)!) { (imageData) in
            DispatchQueue.main.async {
                cell.articlePhotoImageView.image = UIImage(data: imageData)
            }
        }
        return cell
    }
}


