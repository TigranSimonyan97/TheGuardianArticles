//
//  DataModel.swift
//  URLSessionDemo
//
//  Created by Tigran Simonyan on 7/9/18.
//  Copyright © 2018 Tigranakert. All rights reserved.
//

import Foundation


struct DataModel : Codable {
    var status: String
    var userTier: String
    var total: Int
    var startIndex: Int
    var pageSize: Int
    var currentPage: Int
    var pages: Int
    var orderBy: String!
    var results: [ArticleModel]
}
