//
//  LibraryBooksTableViewCell.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/3/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import UIKit

final class LibraryBooksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingControlStackView: RatingControl!
    @IBOutlet weak var dateReadLabel: UILabel!
    
    
    
    private(set) var libraryBook: LibraryBook!
    
    func setup(with libraryBook: LibraryBook) {
        self.libraryBook = libraryBook
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        titleLabel.text = libraryBook.bookTitle
        authorLabel.text = libraryBook.author
        dateReadLabel.text = formatter.string(from: libraryBook.dateRead)
        ratingControlStackView.rating = libraryBook.ratingControl
     }
}


