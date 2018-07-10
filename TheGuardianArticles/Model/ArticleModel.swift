//
//  ArticleModel.swift
//  URLSessionDemo
//
//  Created by Tigran Simonyan on 7/9/18.
//  Copyright © 2018 Tigranakert. All rights reserved.
//

import Foundation

struct ArticleModel : Codable {
    var id: String
    var type: String
    var sectionId: String
    var sectionName: String
    var webPublicationDate: String
    var webTitle: String
    var webUrl: String
    var apiUrl: String
    var fields: [String: String]
    var tags: [TagModel] = [TagModel]()
    var isHosted: Bool
    var pillarId: String
    var pillarName: String
}
