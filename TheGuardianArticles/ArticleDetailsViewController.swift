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
    
    var article: ArticleModel!
    
    var tags = [String]()
    
    var mostUsedWords = [String]()
    var mostUsedWordsCount = [String: Int]()
    
    var widthPerRow: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTitleLabel.text = article.webTitle
        let wordsInTitle = wordsCountInText(article.webTitle)
        tags = Array(wordsInTitle.keys)
        configureTagsCollectionView()
        tagsCollectionView.reloadData()
        
        configureMostUsedWordsTableVIew()

        authorNameHolderView.layer.cornerRadius = 80.0 / 2 // 80 is height of authorNameHolderView
        
        articleBodyLabel.text = article.fields["bodyText"]
    }
    
    fileprivate func configureTagsCollectionView() {
        tagsCollectionViewHeightConstraint.constant = tags.first!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)]).height + 10
        tagsCollectionView.isScrollEnabled = false
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
    }
    
    fileprivate func configureMostUsedWordsTableVIew() {
        mostUsedWordsTableVIew.isScrollEnabled = false
        mostUsedWordsTableVIew.delegate = self
        mostUsedWordsTableVIew.dataSource = self
    }

    fileprivate func wordsCountInText(_ text: String) -> [String: Int] {
        var wordsWithCountInText = [String: Int]()
        var array = text.split(separator: " ")
        
        var finalArray = [String]()
        for item in 0 ..< array.count {
            finalArray.append( String(array[item].trimmingCharacters(in: CharacterSet(charactersIn: "!@#$%^&*(),:;"))))
        }
        
        finalArray = finalArray.filter { $0 != "" }
        
        for item in finalArray {
            if let wordCount = wordsWithCountInText[item] {
                wordsWithCountInText[item] = wordCount + 1
            } else {
                wordsWithCountInText[item] = 1
            }
        }
        
        return wordsWithCountInText
    }
}

extension ArticleDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostUsedWords.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Word Count:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "wordsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }

        let mostUsedWord = mostUsedWords[indexPath.row]
        cell?.textLabel?.text = "\(mostUsedWord) (\(mostUsedWordsCount[mostUsedWord]!))"
        return cell!
    }
}

extension ArticleDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wordSize = tags[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)])
        let cellHeight = wordSize.height + 10
        let cellWidth =  wordSize.width + 10
        
        widthPerRow += cellWidth
        if widthPerRow > tagsCollectionView.frame.width {
            tagsCollectionViewHeightConstraint.constant += cellHeight + 5 // 5 is space between rows
            widthPerRow = 0
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCell
        
        cell.tagLabel.text = tags[indexPath.item]
        
        return cell
    }
}
