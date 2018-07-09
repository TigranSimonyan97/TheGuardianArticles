//
//  ArticleDetailsViewController.swift
//  TheGuardianArticles
//
//  Created by Tigran Simonyan on 7/10/18.
//  Copyright © 2018 TigransApps. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var articleBodyLabel: UILabel!
    @IBOutlet weak var mostUsedWordsTableVIew: UITableView!
    @IBOutlet weak var authorNameHolderView: UIView!
    @IBOutlet weak var articleCategoryLabel: UILabel!
    @IBOutlet weak var articlePublishingDateLabe: UILabel!
    
    @IBOutlet weak var tagsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mostUsedWordTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
