//
//  LibraryBooks.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/3/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import Foundation

struct LibraryBook: Codable {
    let id: UUID
    let bookTitle: String
    let author: String
    let numberOfPages: Int
    let dateRead: Date
    let ratingControl: Int
    let notes: String
    
}

extension LibraryBook {
    static var defaultBook: LibraryBook {
        return LibraryBook(id: UUID(), bookTitle: "No Title", author: "No Name", numberOfPages: 1, dateRead: Date(), ratingControl: 0, notes: "No information")
    }
}
