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
    
    func sort(title: String){
        //UIAlert function calls this function and passes in what type of sort a user is requesting.
        //This function will sort accordingly.
        switch title{
        case "Title":
            libraryBooks.sort(){
                $0.bookTitle < $1.bookTitle
            }
        case "Author":
            libraryBooks.sort(){
                $0.author < $1.author
            }
        case "Rating Ascending":
            libraryBooks.sort(){
                $0.ratingControl < $1.ratingControl
            }
        case "Rating Descending":
            libraryBooks.sort(){
                $0.ratingControl > $1.ratingControl
            }
        case "Date Read Ascending":
            libraryBooks.sort(){
                $0.dateRead < $1.dateRead
            }
        case "Date Read Descending":
            libraryBooks.sort(){
                $0.dateRead > $1.dateRead
            }
        default:
            print("Error")
        }
        delegate?.dataRefreshed()
    }
    
    func deleteAllLibraryBooksList(){
        //First we have to fetch each row and delete from persistence file
        //We then have to remove the workout from the structure
        //After the above two is done refresh the tableview
        
        for row in libraryBooks{
            persistence?.deleteFile(libraryBook: row)
        }
        libraryBooks.removeAll()
        delegate?.dataRefreshed()
    }
    
    func deleteSelectedLibraryBooksRow(indexPaths: [IndexPath]){
        //This function will remove a single book recorded from the LibraryBook struct object.
        //indexPath is an array of Int indexPath, so there can be multiple indices.
        //This function is called when a user swipes on a tableview cell and selects delete or selects Delete from editing mode.
        //Reversing the loop through indexPaths array because if we do it in ascending order it will cause a fatal error if the last index
        //is selected.
        
        //let indexes = indexPaths.map{$0.row}
        let indexes = indexPaths.sorted().reversed().map{$0.row}   //this should sort the indexes in descending order
        
        indexes.forEach { persistence?.deleteFile(libraryBook: libraryBooks[$0]) }
        indexes.forEach { libraryBooks.remove(at: $0) }
       
        delegate?.dataRefreshed()
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
