//
//  ViewController.swift
//  Star List
//
//  Created by WANGMING-LIANG on 12/25/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var fetchResults = [Star]()
    
    @IBOutlet weak var tableViewStar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix empty space above first cell
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableViewStar.dataSource = self
        tableViewStar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshResults()
        tableViewStar.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "Star Name: \(fetchResults[indexPath.row].name!)"
        
        cell.detailTextLabel?.text = "Star Age: \(fetchResults[indexPath.row].age!)"
        
        return cell
    }
    
    // Mark: TableView Delegate
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // delete on core data
            managedObjectContext.deleteObject(fetchResults[indexPath.row] as NSManagedObject)
            appDelegate.saveContext()
            
            // delete on array
            fetchResults.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("show detail", sender: "Edit")
    }
    
    
    
    // Mark: Private method
    func refreshResults() {
        // Create a new fetch request using the Box entity
        let fetchRequest = NSFetchRequest(entityName: "Star")
        
        do {
            fetchResults = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [Star])!
            
            for star in fetchResults {
                print(star.name)
            }
            
            print("Star Count: \(fetchResults.count)")
        } catch {
            // do nothing now
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mode = sender {
            if mode as? String == "Edit" {
                let vc = segue.destinationViewController as! StarDetailViewController
                let star = fetchResults[(tableViewStar.indexPathForSelectedRow?.row)!]
                
                vc.currentStarId = star.objectID
            }
        }
    }
    
    

}

