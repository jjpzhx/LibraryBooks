//
//  AddABookModel.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/3/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import Foundation
import struct UIKit.CGFloat

protocol LibraryBooksModelDelegate: class {
    func dismissEdit()
    func dataRefreshed()
}

final class LibraryBooksModel{
    private let persistence: LibraryBookPersistenceInterface?
    private var libraryBooks: [LibraryBook]
    private weak var delegate: LibraryBooksModelDelegate?
    
    let rowHeight: CGFloat =  64.0
    
    var count: Int { return libraryBooks.count }
    
    init(delegate: LibraryBooksModelDelegate){
        self.delegate = delegate
        
        let persistence = ApplicationSession.sharedInstance.persistence
        self.persistence = persistence
        libraryBooks = persistence?.savedLibraryBooks ?? []
    }
}

extension LibraryBooksModel {
    func libraryBooks(atIndex index: Int) -> LibraryBook? {
        //returns a Workout object at a specified index
        return libraryBooks.element(at: index)
    }
}

extension LibraryBooksModel: AddABookModelDelegate {
    func save(libraryBook: LibraryBook) {
        //Check to see if UUID is already in Workout object. If it is then we are in editing mode.
        //Update Workout object by the index returned.
        //Otherwise, append new Workout object to the end.
        if let existingWorkoutIndex = libraryBooks.firstIndex(where: { $0.id == libraryBook.id }) {
            libraryBooks[existingWorkoutIndex] = libraryBook
        } else {
            libraryBooks.append(libraryBook)
        }
        
        persistence?.save(libraryBook: libraryBook)
        delegate?.dismissEdit()
        delegate?.dataRefreshed()
        
    }
}
