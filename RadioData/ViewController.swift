//
//  ViewController.swift
//  RadioData
//
//  Created by John Diczhazy on 12/10/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // Create class variables
    var arrayOfDictionaries:NSMutableArray!
    var plistPath:String!
    var radios: [[String: String]]!
    var sourceValue = ""
    
    // If updateSegue is triggered, send source value to NewRadioViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSegue"{
            if let destinationController = segue.destination as? NewRadioViewController {
                destinationController.destValue = sourceValue
            } else {
                sourceValue = ""
            }
        }
    }
    
    // Load data from RadioList.plist when page loads.
    override func viewWillAppear(_ animated: Bool) {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         plistPath = appDelegate.plistPathInDocument
         arrayOfDictionaries = NSMutableArray(contentsOfFile: plistPath!)
         radios = arrayOfDictionaries as! [[String: String]]
        
         // reloadData() is required to refresh tableView when changes are made.
         self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Determine number of rows in tableView
    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
          return radios.count
    }
    
    // Populate tableView with data from RadioList.plist
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
       let radio = radios[indexPath.row]
        cell.textLabel!.text = "Make: " + radio["make"]! + "  Model: " + radio["model"]! + "  S/N: " + radio["sn"]!
        
       return cell
    }

    // Allow swipe to Edit or Delete functions for each tableView cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // Trigger confirm delete action alert
            let uiAlert = UIAlertController(title: "Delete", message: "Confirm Delete Action", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            // Trigger delete actions with Delete button is pressed
            uiAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                // Remove radio data from array
                self.arrayOfDictionaries.removeObject(at: indexPath.row)
                // Reload data, otherwise, you will get a SIGABRT error
                self.radios = self.arrayOfDictionaries as! [[String: String]]
                // remove deleted row from tableView
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                // Update RadioList.plist
                self.arrayOfDictionaries.write(toFile: self.plistPath, atomically: true)
            }))
            
            // Cancel Delete action
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("Click of cancel button")
            }))
        }
        
        // Trigger updateSegue segue when Edit button is pressed
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.sourceValue = String(indexPath.row)
            self.performSegue(withIdentifier: "updateSegue", sender:tableView)
        }
        
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
}

