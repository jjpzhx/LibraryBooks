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
    private var checkLeftBarButtonItemStatus: Bool {return (model.count > 0 && !tableView.isEditing)}
    private var checkRightBarButtonItemStatus: Bool {return (!tableView.isEditing)}
}

extension LibraryBooksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model = LibraryBooksModel(delegate: self)
        
        //set the "Sort" left UIBarButtonItem so that it will invoke sortTapped to pop up a UIAlertController
        //Since we have two left UIBarButtonItems, we will have to differentiate by an array of leftBarButtonItems
        let sort = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortTapped))
        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        
        //UIToolbar button items
        let deleteAll = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllTapped))
        let deleteSelected = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        //set the buttons on the navigation bar and tool bar
        navigationItem.leftBarButtonItems = [sort, edit]
        toolbarItems = [cancel, spacer, deleteAll, spacer, deleteSelected]
        navigationController?.setToolbarHidden(true, animated: false)
        
        //allow users to select multiple table view cells when in edit mode
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //Disable Edit and Sort navigation bar items if there are no rows in tableview.
        handleLeftBarItems()
    }
    
    @objc func sortTapped(){
        //create an alert for when the uiBarButtonItem is selected (defined in viewDidLoad).
        //use UIAlertController's object to prompt a user for the type of sort to be performed on the structure.
        //Unless if Cancel is selected, it will call sortWorkoutSturct. This will then call model.sort on the WorkoutListModel
        let sortAlert = UIAlertController(title: "Sort Book List By:", message: nil, preferredStyle: .alert)
        sortAlert.addAction(UIAlertAction(title: "Title", style: .default, handler: sortWorkoutStruct))
        sortAlert.addAction(UIAlertAction(title: "Author", style: .default, handler: sortWorkoutStruct))
        sortAlert.addAction(UIAlertAction(title: "Rating Ascending", style: .default, handler: sortWorkoutStruct))
        sortAlert.addAction(UIAlertAction(title: "Rating Descending", style: .default, handler: sortWorkoutStruct))
        sortAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sortAlert.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        present(sortAlert, animated: true)
    }
    
    @objc func deleteAllTapped(){
        //create an alert for when the uiBarButtonItem is selected (defined in viewDidLoad).
        //use UIAlertController's object to prompt a user if they are sure about deleting all workout list items.
        //Unless if Cancel is selected, it will delete the persistence file, the libraryBooks list, and refresh the tableview.
        let deleteAllAlert = UIAlertController(title: "Delete Library Books List", message: "Are you sure you want to delete all book items recorded? You cannot recover them if Yes is selected.", preferredStyle: .alert)
        deleteAllAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: deleteAllLibraryBooksList))
        deleteAllAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAllAlert.popoverPresentationController?.barButtonItem  = self.navigationItem.leftBarButtonItem
        present(deleteAllAlert, animated: true)
        handleRightBarItems()
    }
    
    @objc func deleteSelectedTapped(){
        //create an alert for when the uiBarButtonItem is selected (defined in viewDidLoad).
        //use UIAlertController's object to prompt a user if they are sure about deleting all book list items selected.
        //Unless if Cancel is selected, it will delete the persistence file, the libraryBooks list, and refresh the tableview.
        if let selectedRows = tableView.indexPathsForSelectedRows{
            
            let deleteAlert = UIAlertController(title: "Delete \(selectedRows.count) items?", message: "Are you sure you want to delete \(selectedRows.count) items? You cannot recover them if Yes is selected.", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: deleteSelectedLibraryBooksList))
            deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            deleteAlert.popoverPresentationController?.barButtonItem  = self.navigationItem.leftBarButtonItem
            present(deleteAlert, animated: true)
        }
        handleRightBarItems()
    }
    
    @objc func cancelTapped(){
        //This function will simply go out of edit mode and hide the toolbar
        navigationController?.setToolbarHidden(true, animated: false)
        tableView.isEditing = false
        handleLeftBarItems()
        handleRightBarItems()
        
    }
    
    @objc func editTapped(){
        //Make Toolbar appear on the screen
        tableView.isEditing  = true
        navigationController?.setToolbarHidden(false, animated: false)
        toolbarItems?.element(at: 4)?.isEnabled = false
        handleLeftBarItems()
        handleRightBarItems()
    }
    
    func handleLeftBarItems(){
        //This function will set the Sort and Edit navigation bar button item to disabled if there are no Workout list items.
        navigationItem.leftBarButtonItems![0].isEnabled = checkLeftBarButtonItemStatus
        navigationItem.leftBarButtonItems![1].isEnabled = checkLeftBarButtonItemStatus
    }
    
    func handleRightBarItems(){
        navigationItem.rightBarButtonItems![0].isEnabled = checkRightBarButtonItemStatus
    }
    
    func sortWorkoutStruct(action: UIAlertAction){
        //this function will use the title of the UIAlertAction and call WorkoutListModel.sort
        //In WorkoutListModel.sort it will use the title in a case statement to determine what field to sort on in what order
        model.sort(title: action.title!)
    }
    
    func deleteAllLibraryBooksList(action: UIAlertAction){
        //This function will call deleteAllWorkoutList in WorkoutListModel.
        //WorkoutListModel will proceed to delete all persistence files associated with Workout objects one-by-one, delete all rows of Workout
        //object, and refresh the tableview.
        
        tableView.isEditing = false
        navigationController?.setToolbarHidden(true, animated: false)
        model.deleteAllLibraryBooksList()
    }
    
    func deleteSelectedLibraryBooksList(action: UIAlertAction){
        if let selectedRows = tableView.indexPathsForSelectedRows{
            tableView.isEditing = false
            navigationController?.setToolbarHidden(true, animated: false)
            model.deleteSelectedLibraryBooksRow(indexPaths: selectedRows)
        }
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
            model.deleteSelectedLibraryBooksRow(indexPaths: [indexPath])
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
                toolbarItems?.element(at: 4)?.title = "Delete \(selectedRows.count)"
                toolbarItems?.element(at: 4)?.isEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //Detect when a user deselects a row in tableView.
        //Update Delete button text and disable if necessary
        if (tableView.isEditing){
            if let selectedRows = tableView.indexPathsForSelectedRows{
                //there are still rows left. Update the Delete button text
                toolbarItems?.element(at: 4)?.title = "Delete \(selectedRows.count)"
            }
            else{
                //case when there are no rows selected
                toolbarItems?.element(at: 4)?.title = "Delete"
                toolbarItems?.element(at: 4)?.isEnabled = false
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
        handleLeftBarItems()
        handleRightBarItems()
    }
}

