//
//  PeopleMetViewController.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import UIKit

class PeopleMetViewController: UITableViewController {
    
    let CELL_ID = "peopleMeetCellTemplate";
    var toPeopleMeetFormMode:FormMode = FormMode.ADD
    var peopleMeetToEdit:PeopleMeet?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeetingService.sharedInstance.count();
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        let peopleMeet = MeetingService.sharedInstance.findAt(pos: indexPath.row);
        cell.textLabel?.text = (peopleMeet?.firstname)! + " " + (peopleMeet?.lastname)!;
        cell.detailTextLabel?.text = dateFormatter.string(from: (peopleMeet?.birthdate)!) + " - " + (peopleMeet?.sexe.rawValue)!
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let this = self
        let delete = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, indexPath) in
            
            var refreshAlert = UIAlertController(title: "Suppression", message: "Êtes-vous sur de vouloir supprimer cette rencontre ?", preferredStyle: .alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Confirmer", style: .default, handler: { (action: UIAlertAction!) in
                MeetingService.sharedInstance.delete(this: MeetingService.sharedInstance.findAt(pos: indexPath.row)!)
                tableView.reloadData();
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler:nil))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Modifier") { (action, indexPath) in
            self.peopleMeetToEdit = MeetingService.sharedInstance.findAt(pos: indexPath.row)
            self.toPeopleMeetFormMode = FormMode.EDIT
            this.performSegue(withIdentifier: "toPeopleMeetForm", sender: self)
        }
        
        share.backgroundColor = UIColor.blue;
        
        return [delete, share]
    }
    
    @IBAction func unwindToPeopleMeetListViewController(segue: UIStoryboardSegue){
        tableView.reloadData();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "toPeopleMeetForm":
                if let destinationController = segue.destination as? PeopleMeetFormTableViewController{
                    destinationController.mode = self.toPeopleMeetFormMode
                    destinationController.peopleMeetToEdit = self.peopleMeetToEdit
                }
                break;
            default:
                break;
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
