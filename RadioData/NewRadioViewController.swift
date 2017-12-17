//
//  NewNoteViewController.swift
//  RadioData
//
//  Created by John Diczhazy on 12/10/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class NewRadioViewController: UIViewController {
    
    // Create class variables
    var destValue = ""
    var arrayOfDictionaries:NSMutableArray!
    var plistPath:String!
    var radios: [[String: String]]!

    @IBOutlet weak var makeTxt: UITextField!
    
    @IBOutlet weak var modelTxt: UITextField!
    
    @IBOutlet weak var snTxt: UITextField!
    
    // Save Radio Data to Radiolist.plist
    @IBAction func saveBtn(_ sender: AnyObject) {
        
        // Call validate function to ensure data was entered in fields
        if validate() == true {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let pathForThePlistFile = appDelegate.plistPathInDocument

            // Extract the content of the file as NSData
            let data:Data =  FileManager.default.contents(atPath: pathForThePlistFile)!
            // Convert the NSData to mutable array
                do{
                    let newRadio:[String:String] = ["make":makeTxt.text!,"model":modelTxt.text!,"sn":snTxt.text!]
                    let radioArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
                            // Determine if we are adding or updating Radio data
                            if Int32(destValue) != nil{
                                radioArray[Int(destValue)!] = newRadio
                            } else {
                                radioArray.add(newRadio)
                            }
                    // Save to plist
                    radioArray.write(toFile: pathForThePlistFile, atomically: true)
                }catch{
            print("An error occurred while writing to plist")
        }
        // Dismiss the modal controller
        self.dismiss(animated: true, completion: nil)
        }
    }
        
    // Cancel Add or Edit action
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.makeTxt.becomeFirstResponder()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let pathForThePlistFile = appDelegate.plistPathInDocument
        // Load data if editing
        if Int32(destValue) != nil {
            arrayOfDictionaries = NSMutableArray(contentsOfFile:pathForThePlistFile)
            radios = arrayOfDictionaries as! [[String: String]]
            let radio = radios[Int(destValue)!]
            makeTxt.text = radio["make"]
            modelTxt.text = radio["model"]
            snTxt.text = radio["sn"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Validate function used to ensure data was entered in fields
    func validate() ->Bool {
        if (makeTxt.text?.isEmpty)! {
            // Trigger alert fucntion
            alert(input: "Make is a required field!")
            self.makeTxt.becomeFirstResponder()
            return false
        } else if (modelTxt.text?.isEmpty)! {
            // Trigger alert fucntion
            alert(input: "Model is a required field!")
            self.modelTxt.becomeFirstResponder()
            return false
        } else if(snTxt.text?.isEmpty)! {
            // Trigger alert fucntion
            alert(input: "SerialNO is a required field!")
            self.snTxt.becomeFirstResponder()
            return false
        } else {
            self.makeTxt.becomeFirstResponder()
            return true
        }
    }
    
    // Alert function is called from Validate function
    func alert (input: String){
        let alertController = UIAlertController(title: "Alert", message: input, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
    
    
    
    

