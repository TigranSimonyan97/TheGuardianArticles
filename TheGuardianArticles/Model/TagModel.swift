//
//  TagModel.swift
//  TheGuardianArticles
//
//  Created by Tigran Simonyan on 7/10/18.
//  Copyright © 2018 TigransApps. All rights reserved.
//

import Foundation

struct TagModel: Codable {
    var id: String
    var type: String
    var webTitle: String
    var webUrl: String
    var apiUrl: String
    var references: [String]?
    var bio: String?
    var bylineImageUrl: String?
    var bylineLargeImageUrl: String?
    var firstName: String
    var lastName: String?
    var emailAddress: String?
    var twitterHandle: String?
}
