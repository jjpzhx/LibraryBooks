//
//  LibraryBooksViewController.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/4/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import UIKit


final class LibraryBooksViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
     private var model: LibraryBooksModel!
    

    
    
}

extension LibraryBooksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model = LibraryBooksModel(delegate: self)
        print("tableview did load")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //This function will prepare the instantiation of WorkoutCreationModel
        //If we are in editing mode, we will have to let WorkOutCreationModel that we are in that mode by setting
        //isEditing = true. We accomplish that by testing whether sender is a Workout object or a UIBarButtonItem action.
        //This variable is passed into WorkoutCreationModel's editing parameter which will update their isEditing variable.
        
        if let addABookViewController = segue.destination as? AddABookViewController {
            let libraryBook: LibraryBook = sender as? LibraryBook ?? .defaultBook
            let isEditing = (sender as? LibraryBook) != nil
            
            let addABookModel = AddABookModel(libraryBook: libraryBook, delegate: model, isEditing: isEditing)
            addABookViewController.setup(model: addABookModel)
        }
    }
}

extension LibraryBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Allow the tableview to know how many rows to display
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //returns the tableview cell when clicked
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookList", for: indexPath) as! LibraryBooksTableViewCell
        cell.setup(with: model.libraryBooks(atIndex: indexPath.row)!)
        
        return cell
    }
}

extension LibraryBooksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //Another way this step below can be called is if a user goes into Edit mode and selects one or more rows to delete.
            //model.deleteSelectedWorkoutListRow(indexPaths: [indexPath])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return model.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //calls a segue to AddABook story board when selected.
        //prepare function will pass in all necessary parameters for initiation
        
        //If tableView is in editing mode (edit button clicked on navigation bar), then do not perform a
        //segue to AddABook
        if (!tableView.isEditing){
            let cell = tableView.cellForRow(at: indexPath) as! LibraryBooksTableViewCell
            
            performSegue(withIdentifier: "AddABook", sender: cell.libraryBook)
        }
        else{
            //check to see if rows are selected when in edit mode
            if let selectedRows = tableView.indexPathsForSelectedRows{
                //                toolbarItems?.element(at: 4)?.title = "Delete \(selectedRows.count)"
                //                toolbarItems?.element(at: 4)?.isEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //Detect when a user deselects a row in tableView.
        //Update Delete button text and disable if necessary
        if (tableView.isEditing){
            if let selectedRows = tableView.indexPathsForSelectedRows{
                //there are still rows left. Update the Delete button text
                //                toolbarItems?.element(at: 4)?.title = "Delete \(selectedRows.count)"
            }
            else{
                //case when there are no rows selected
                //                toolbarItems?.element(at: 4)?.title = "Delete"
                //                toolbarItems?.element(at: 4)?.isEnabled = false
            }
        }
    }
}


extension LibraryBooksViewController: LibraryBooksModelDelegate {
    func dismissEdit() {
        navigationController?.popViewController(animated: true)
    }
    
    func dataRefreshed() {
        //refresh tableview
        tableView.reloadData()
        //handleLeftBarItems()
    }
}

