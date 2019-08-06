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
    
    private(set) var libraryBook: LibraryBook!
    
    func setup(with libraryBook: LibraryBook) {
        self.libraryBook = libraryBook
        
        titleLabel.text = libraryBook.bookTitle
        authorLabel.text = libraryBook.author
 
    }
}


