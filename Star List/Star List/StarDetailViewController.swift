//
//  StarDetailViewController.swift
//  Star List
//
//  Created by WANGMING-LIANG on 12/25/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import CoreData

class StarDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var textFieldStarName: UITextField!
    @IBOutlet weak var pickerAge: UIPickerView!

    var ageArray = [Int]()
    var currentStarId: NSManagedObjectID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initAgeData()
        pickerAge.dataSource = self
        pickerAge.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveStar(sender: AnyObject) {
        if let id = currentStarId {
            do {
                let star = try managedObjectContext.existingObjectWithID(id) as! Star
                star.name = textFieldStarName.text
                star.age = ageArray[pickerAge.selectedRowInComponent(0)]
            } catch {
                
            }
        } else {
            let star = NSEntityDescription.insertNewObjectForEntityForName("Star", inManagedObjectContext: self.managedObjectContext) as! Star
            star.name = textFieldStarName.text
            star.age = ageArray[pickerAge.selectedRowInComponent(0)]
        }
        
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(ageArray[row])"
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
