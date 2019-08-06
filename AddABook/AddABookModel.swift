//
//  AddABookModel.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/3/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import Foundation

protocol AddABookModelDelegate: class{
    func save(libraryBook: LibraryBook)
}

final class AddABookModel {
    
    private(set) var libraryBook: LibraryBook
    private weak var delegate: AddABookModelDelegate?
    
    //vars added for convenience
    private var isEditing: Bool
    //The following two functions will aid in updating the navigation title and the button text accordingly depending on if it is
    //in edit mode or add mode.
    var buttonText: String { return isEditing ? "Update Book" : "Add Book" }
    var titleText: String { return isEditing ? "Update a Book" : "Add a Book" }
    
    init(libraryBook: LibraryBook, delegate: AddABookModelDelegate, isEditing: Bool){
        self.libraryBook = libraryBook
        self.delegate = delegate
        self.isEditing = isEditing          //this will tell you if LibaryBooksViewController is in edit mode or not
    }
}

extension AddABookModel{
    func saveLibraryBook(bookTitle: String, author: String, numberOfPages: Int, dateRead: Date, ratingControl: Int, notes: String){
        delegate?.save(libraryBook: LibraryBook(
            id: libraryBook.id,
            bookTitle: bookTitle.isEmpty ? libraryBook.bookTitle : bookTitle,
            author: author,
            numberOfPages: numberOfPages,
            dateRead: dateRead,
            ratingControl: ratingControl,
            notes: notes
            )
        )
    }
    
    func validateField(bookTitle: String = "", author: String = "", numberOfPages: Int = 0, dateRead: Date, ratingControl: Int = -1)->(Bool){
        //This function will validate all fields that requires to be checked.
        //If the parameters come in nil, then a value that will not pass the validation are passed in.
        //  1) Title must be filled. It cannot be "No Title" or "".
        //  2) Author must be filled. It cannot be "No Name" or "".
        //  3) Number of Pages must be a numeric value >= 1.
        //  4) Date Read must be a date forrmat and cannot be greater than today.
        //  5) Rating control is an Integer value 0 <= Rating Control <= 5
        //  6) Notes can actually be blank. Not passed in for validation.
        
        //var test: Bool = true
        
        //Test 1
        if (bookTitle == "" || bookTitle == "No Title"){
            return false
        }
        //Test 2
        else if (author == "" || author == "No Name"){
            return false
        }
        //Test 3
        else if (numberOfPages < 1){
            return false
        }
        //Test 4    <-- This should never happen
        else if (dateRead > Date()){
            return false
        }
        else if (ratingControl < 0 || ratingControl > 5){
            return false
        }
        else{
            return true
        }    
    }
}
