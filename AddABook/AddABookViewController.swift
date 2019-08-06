//
//  AddABookViewController.swift
//  LibraryBooks
//
//  Created by Jess Payton on 8/3/19.
//  Copyright © 2019 Jess Payton. All rights reserved.
//

import UIKit

final class AddABookViewController: UIViewController {
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var numberOfPages: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var dateReadTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var datePicker: UIDatePicker!
    private var model: AddABookModel!
    //validate text field
    //If the Title and Author is left blank, or if those fields have "No Title" / "No Name", then return false.
    private var validateTitleField: Bool {return (bookTitleTextField.text != "No Title" && bookTitleTextField.text != "")}
    private var validateAuthorField: Bool {return (authorTextField.text != "No Name" && authorTextField.text != "")}
    
}

extension AddABookViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Update standard Text Fields/Text Views
        bookTitleTextField.text = model.libraryBook.bookTitle
        authorTextField.text = model.libraryBook.author
        noteTextView.text = model.libraryBook.notes
        
        //Set dateReadTextField as a UIDatePicker object
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.maximumDate = Date() 
        
        datePicker.date = model.libraryBook.dateRead
        
        datePicker.addTarget(self, action: #selector(AddABookViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    
        dateReadTextField.inputView = datePicker
        dateReadTextField.text = datePicker.date.toString(format: .yearMonthDay)
        
        //Set keyboard type to numberpad on numberofPages text field
        numberOfPages.keyboardType = UIKeyboardType.numberPad
        numberOfPages.text = String(model.libraryBook.numberOfPages)
        
        //Update Book Title and Author Text Field if it is set to default value
        initializeTitle()
        initializeAuthor()
        
        //Initialize the Save Button
        saveButton.isEnabled = model.validateField(bookTitle: model.libraryBook.bookTitle, author: model.libraryBook.author, numberOfPages: model.libraryBook.numberOfPages, dateRead: model.libraryBook.dateRead, ratingControl: model.libraryBook.ratingControl)
        saveButton.setTitle(model.buttonText, for: .normal)
        setSaveButtonAttribute()
        
        //Initialize Navigation Bar
        navigationItem.title = model.titleText
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
       




       model.saveLibraryBook(bookTitle: bookTitleTextField.text ?? "",
                              author: authorTextField.text ?? "",
                              numberOfPages: Int(numberOfPages.text ?? "") ?? 0,
                              dateRead: datePicker.date,
                              ratingControl: ratingControl.rating,
                              notes: noteTextView.text ?? "")
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
                let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dateReadTextField.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func initializeTitle(){
        //This function will look at the bookTitle to determine if the libraryBook object is a brand new object or not. If it is a new object by
        //bookTitle == "No Title", then move that text to placeholder so users do not have to delete the text and type in the real title.
        //This function only will enable/disable the add button. No need to repeat it in initializeAuthor.
        if (model.libraryBook.bookTitle == "No Title"){
            bookTitleTextField.placeholder = "No Title"
            bookTitleTextField.text = ""
            
        }
        else{
            bookTitleTextField.text = model.libraryBook.bookTitle
            
        }
    }
    
    private func initializeAuthor(){
        //This function will look at the author and place the text as a placeholder if it says "No Name".
        //initializeTitle already took care of disabling/enabling the add button. This function will not alter the property.
        if (model.libraryBook.author == "No Name"){
            authorTextField.placeholder = "No Name"
            authorTextField.text = ""
        }
        else{
            authorTextField.text = model.libraryBook.author            
        }
    }
    
    private func setSaveButtonAttribute(){
        if (saveButton.isEnabled){
            saveButton.backgroundColor = UIColor.blue
        }
        else {
            saveButton.backgroundColor = UIColor.lightGray
        }
    }
}

extension AddABookViewController{
    func setup(model: AddABookModel){
        self.model = model
    }
}

extension AddABookViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        saveButton.isEnabled = model.validateField(bookTitle: bookTitleTextField.text ?? "", author: authorTextField.text ?? "", numberOfPages: Int(numberOfPages.text ?? "") ?? 0, dateRead: datePicker.date, ratingControl: ratingControl.rating)      //set enable properties by testing to see if a workout name is populated
        setSaveButtonAttribute()
        
        return true
    }
}

extension AddABookViewController{
    
}

