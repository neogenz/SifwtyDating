//
//  PeopleMeetFormTableViewController.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 22/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import UIKit

class PeopleMeetFormTableViewController: UITableViewController {
    
    @IBOutlet weak var sexeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthdateDatepicker: UIDatePicker!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var noteSlide: UISlider!
    @IBOutlet weak var noteLabel: UILabel!
    var cancelButton: UIBarButtonItem!;
    var validButton: UIBarButtonItem!;
    var mode:FormMode = FormMode.ADD
    var peopleMeetToEdit:PeopleMeet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdateDatepicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        cancelButton = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(PeopleMeetFormTableViewController.cancelAndPerformToBackSegue))
        validButton = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(PeopleMeetFormTableViewController.addPeopleMeet))
        validButton.isEnabled = false
        navigationItem.leftBarButtonItems = [cancelButton];
        navigationItem.rightBarButtonItems = [validButton];
        
        if(mode == FormMode.EDIT){
            do{
                try initFormWithPeopleMeetToEdit()
            }catch PeopleMeetFormError.NoPeopleToEdit {
                print("Aucune personne à éditer.")
            }catch{
                print(error)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noteSliderValueChanged(_ sender: UISlider) {
        let currentNote = Int(sender.value)
        noteLabel.text = "\(currentNote)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (!(lastnameTextField.text?.isEmpty ?? true ) && !(firstnameTextField.text?.isEmpty ?? true)) {
            validButton.isEnabled = true;
        }else{
            validButton.isEnabled = false;
        }
        if (lastnameTextField.text?.isEmpty ?? true) {
            firstnameTextField.enablesReturnKeyAutomatically = false;
            textField.resignFirstResponder()
        }
        else if textField == lastnameTextField {
            firstnameTextField.enablesReturnKeyAutomatically = true
            firstnameTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func cancelAndPerformToBackSegue() {
        self.view.endEditing(true)
        performSegue(withIdentifier: "backToPeopleMeetListViewController", sender: self)
    }
    
    @IBAction func firstnameTextFieldEditingChanged(_ sender: Any) {
        validButton.isEnabled = calculValidButtonState();
    }
    
    @IBAction func lastnameTextFieldEditingChanged(_ sender: Any) {
        validButton.isEnabled = calculValidButtonState();
    }
    
    func calculValidButtonState() -> Bool {
        if (!(lastnameTextField.text?.isEmpty ?? true ) && !(firstnameTextField.text?.isEmpty ?? true)) {
            return true;
        }else{
            return false;
        }
    }
    
    func addPeopleMeet(){
        self.view.endEditing(true)
        MeetingService.sharedInstance.create(this: PeopleMeet(firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, birthdate: birthdateDatepicker.date, sexe: getSexeSelected().rawValue, note: Int(noteSlide.value)))
        performSegue(withIdentifier: "backToPeopleMeetListViewController", sender: self)
    }
    
    func updatePeopleMeet(){
        self.view.endEditing(true)
        MeetingService.sharedInstance.update(peopleMeet: PeopleMeet(id:(peopleMeetToEdit?.id)!, firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, birthdate: birthdateDatepicker.date, sexe: getSexeSelected().rawValue, note: Int(noteSlide.value)))
        performSegue(withIdentifier: "backToPeopleMeetListViewController", sender: self)
    }
    
    func getSexeSelected() -> Gender{
        switch sexeSegmentedControl.selectedSegmentIndex {
        case 0:
            return Gender.MAN
        case 1:
            return Gender.WOMAN
        default:
            return Gender.MAN
        }
    }
    
    func getSexeSegmentedValue(by gender:Gender) -> Int{
        switch gender {
        case Gender.MAN:
            return 0
        case Gender.WOMAN:
            return 1
        default:
            return 0
        }
    }
    
    
    func initFormWithPeopleMeetToEdit() throws {
        if let peopleToEdit = self.peopleMeetToEdit{
            lastnameTextField.text = peopleToEdit.lastname
            firstnameTextField.text = peopleToEdit.firstname
            birthdateDatepicker.date = peopleToEdit.birthdate
            sexeSegmentedControl.selectedSegmentIndex = getSexeSegmentedValue(by: peopleToEdit.sexe)
            noteSlide.value = Float(peopleToEdit.note)
            validButton.title = "Valider"
            validButton.isEnabled = true
            validButton.action = #selector(PeopleMeetFormTableViewController.updatePeopleMeet)
            navigationItem.title = ""
        }else{
            throw PeopleMeetFormError.NoPeopleToEdit
        }
    }
}
