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
    @IBOutlet weak var mostUsedWordsTableView: UITableView!
    @IBOutlet weak var authorNameHolderView: UIView!
    @IBOutlet weak var articleCategoryLabel: UILabel!
    @IBOutlet weak var articlePublishingDateLabe: UILabel!
    
    @IBOutlet weak var tagsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mostUsedWordTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorNameTopConstraintToBodyText: NSLayoutConstraint!
    @IBOutlet weak var authorNameTopConstraintToMostUsedWord: NSLayoutConstraint!
    
    var article: ArticleModel!
    
    var tags = [String]()
    
    var mostUsedWords = [String]()
    var mostUsedWordsWithCount = [String: Int]()
    
    var widthPerRow: CGFloat = 0.0
    
    let wordCellHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTitleLabel.text = article.webTitle
        let wordsInTitle = wordsCountInText(article.webTitle)
        tags = Array(wordsInTitle.keys)
        configureTagsCollectionView()
        tagsCollectionView.reloadData()
        

        authorNameHolderView.layer.cornerRadius = 80.0 / 2 // 80 is height of authorNameHolderView
        
        articleBodyLabel.text = article.fields["bodyText"]
        
        prepareMostUsedWords()
        configureMostUsedWordsTableView()
    }
    
    fileprivate func configureTagsCollectionView() {
        tagsCollectionViewHeightConstraint.constant = tags.first!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)]).height + 10
        tagsCollectionView.isScrollEnabled = false
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
    }
    
    fileprivate func configureMostUsedWordsTableView() {
        if mostUsedWords.count == 0 {
            mostUsedWordsTableView.isHidden = true
            authorNameTopConstraintToBodyText.isActive = true
            authorNameTopConstraintToMostUsedWord.isActive = false
            return
        } else {
            mostUsedWordsTableView.estimatedRowHeight = wordCellHeight
            mostUsedWordsTableView.rowHeight = UITableView.automaticDimension
            mostUsedWordTableViewHeightConstraint.constant = CGFloat(mostUsedWords.count) * wordCellHeight + mostUsedWordsTableView.sectionHeaderHeight
        }
        mostUsedWordsTableView.isScrollEnabled = false
        mostUsedWordsTableView.delegate = self
        mostUsedWordsTableView.dataSource = self
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
    
    fileprivate func prepareMostUsedWords() {
        mostUsedWordsWithCount = wordsCountInText(article.fields["bodyText"]!)
        mostUsedWordsWithCount = mostUsedWordsWithCount.filter({ $1 >= 10 })
        
        if mostUsedWordsWithCount.count > 3 {
            let sortedArrayByWordsCount = mostUsedWordsWithCount.sorted { $0.value > $1.value }[0..<3]
            for item in sortedArrayByWordsCount {
                mostUsedWords.append("\(item.key) (\(item.value))")
            }
        } else {
            for (key, value) in mostUsedWordsWithCount {
                mostUsedWords.append("\(key) (\(value))")
            }
        }
    }
    
    fileprivate func highlightSelectedWord(_ word: String) {
        guard let pattern = try? NSRegularExpression(pattern: word, options: []) else { return }
        let bodyText = article.fields["bodyText"]!

        let attributedBody = NSMutableAttributedString(string: article.fields["bodyText"]!)
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        
        let matches = pattern.matches(in: bodyText, options: [], range: NSRange(0..<bodyText.count))
        
        for match in matches {
            let wordNextCharacterStartIndex = bodyText.index(bodyText.startIndex, offsetBy: match.range.upperBound)
            let wordNextCharacterEndIndex = bodyText.index(bodyText.startIndex, offsetBy: match.range.upperBound + 1)
            let wordPreviousCharacterStartIndex = bodyText.index(bodyText.startIndex, offsetBy: match.range.lowerBound - 1)
            let wordPreviousCharacterEndIndex = bodyText.index(bodyText.startIndex, offsetBy: match.range.lowerBound)
            
            let nextCharacter = bodyText[wordNextCharacterStartIndex..<wordNextCharacterEndIndex]
            let previousCharacter = bodyText[wordPreviousCharacterStartIndex..<wordPreviousCharacterEndIndex]
            
            if nextCharacter == " ", previousCharacter == " " {
                attributedBody.addAttributes(attributes, range: match.range)
            } else { continue }
        }

        self.articleBodyLabel.attributedText = attributedBody
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.headerView(forSection: 0) {
        view.backgroundColor = .clear
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "wordsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }

        cell?.textLabel?.text = mostUsedWords[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let word = mostUsedWords[indexPath.row].split(separator: " ").first {
            highlightSelectedWord(String(word))
        }
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

extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }

}
