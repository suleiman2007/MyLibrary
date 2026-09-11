//
//  Book.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftData
import Foundation

enum BookStatus: String, Codable {
    case reading
    case read
    case toRead
}

@Model
class Book {
    var title: String
    var author: String
    var rating: Double
    var bookDescription: String
    var review: String
    var image: Data?
    var bookStatus: BookStatus

    init(
        title: String,
        author: String,
        rating: Double,
        bookDescription: String,
        review: String,
        image: Data? = nil,
        bookStatus: BookStatus
    ) {
        self.title = title
        self.author = author
        self.rating = rating
        self.bookDescription = bookDescription
        self.review = review
        self.image = image
        self.bookStatus = bookStatus
    }
}


