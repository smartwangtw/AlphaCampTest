//
//  StarDetailViewController.swift
//  Star List
//
//  Created by WANGMING-LIANG on 12/25/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import CoreData

class StarDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var textFieldStarName: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var pickerAge: UIPickerView!


    var ageArray = [Int]()
    var star: Star?
    var currentStarId: NSManagedObjectID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldStarName.delegate = self
        textFieldAge.delegate = self
        
        initAgeData()
        pickerAge.dataSource = self
        pickerAge.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let id = currentStarId {
            do {
                star = try managedObjectContext.existingObjectWithID(id) as? Star
                textFieldStarName.text = star!.name
                textFieldAge.text = "\(star!.age!)"
            } catch {
                //
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchTextFieldAge(sender: UITextField) {
        print("Touch")
    }
    
    @IBAction func saveStar(sender: AnyObject) {
        if star == nil {
            star = NSEntityDescription.insertNewObjectForEntityForName("Star", inManagedObjectContext: self.managedObjectContext) as? Star
        }
        star!.name = textFieldStarName.text
        star!.age = Int(textFieldAge.text!)!
        
        appDelegate.saveContext()
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Mark: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    // Mark: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(ageArray[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldAge.text = "\(ageArray[row])"
    }
    
    // Mark: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == textFieldAge {
            pickerAge.selectRow(Int(textFieldAge.text!)! - 1, inComponent: 0, animated: false)
            pickerAge.hidden = false
            return false
        }
        
        if textField == textFieldStarName {
            pickerAge.hidden = true
            return true
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textFieldStarName {
            textField.resignFirstResponder()
            return true
        }
        
        return false

    }
    
    // Mark: Private method
    func initAgeData() {
        let ageMin = 1
        let ageMax = 95
        
        for age in ageMin...ageMax {
            ageArray.append(age)
        }
    }

}
