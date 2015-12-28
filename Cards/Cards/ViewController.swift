//
//  ViewController.swift
//  Cards
//
//  Created by WANGMING-LIANG on 12/28/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import Parse
import CoreData

class ViewController: UIViewController, UIPageViewControllerDataSource {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var pageViewController: UIPageViewController?
    
    var cardArray: [Card] = []

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelTotalCards: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageVIewController") as? UIPageViewController
        pageViewController?.dataSource = self
        
        
        // load cards from core data
        refreshLocalResults()
        
        // Sample display
        if cardArray.count == 0 {
            let card = NSEntityDescription.insertNewObjectForEntityForName("Card", inManagedObjectContext: self.managedObjectContext) as! Card
            card.image = UIImageJPEGRepresentation(UIImage(named: "Cloth1")!, 1.0)
            card.title = "Sample"
            card.desc = "Sample desc"
            
            cardArray.append(card)
        }
        
        // initial page controller to first page
        initPage()
        
        pageViewController?.view.frame = CGRectMake(0, 0, viewContainer.frame.size.width, viewContainer.frame.size.height);
        addChildViewController(pageViewController!)
        viewContainer.addSubview((pageViewController?.view)!)
        
        pageViewController?.didMoveToParentViewController(self)
    }

    @IBAction func get1Card(sender: UIButton) {
        loadParse1Card()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: UIPageViewControllerDataSource
    // move backward
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        
        if index == 0 {
            return nil
        }
        
        index = index - 1
        
        return viewControllerAtIndex(index)
    }
    
    // move foreward
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        index = index + 1
        
        if index == cardArray.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return cardArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // Mark: Private method
    // create content view controller by index of cards
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if index >= cardArray.count || cardArray.count == 0 {
            return nil
        }
        
        let pageContentVC = storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! PageContentViewController
        pageContentVC.cardTitle = cardArray[index].title!
        pageContentVC.cardDesc = cardArray[index].desc!
        pageContentVC.cardImage = UIImage(data: cardArray[index].image!)
        pageContentVC.pageIndex = index
        
        return pageContentVC
    }
    
    // reload local cards from core data
    func refreshLocalResults() {
        // Create a new fetch request using the Box entity
        let fetchRequest = NSFetchRequest(entityName: "Card")
        let sort: NSSortDescriptor = NSSortDescriptor(key: "addTime", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            cardArray = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [Card])!

            self.labelTotalCards.text = "Total: \(self.cardArray.count) card(s)"
            
            print("Fetch count: \(cardArray.count)")
        } catch {
            // do nothing now
        }
        
    }
    
    // load random 1 card from Parse
    func loadParse1Card() {
        let query = PFQuery(className: "CardObject")
        query.findObjectsInBackgroundWithBlock { (cards, error) -> Void in
            if error == nil {
                self.managedObjectContext.rollback()
                
                print("Successfully retrieved: \(cards)")
                let index = self.random1Number((cards?.count)!)
                
                
                // save loaded card to core data
                let card = NSEntityDescription.insertNewObjectForEntityForName("Card", inManagedObjectContext: self.managedObjectContext) as! Card
                let imageFile = cards![index]["image"] as! PFFile
                do {
                    let imageData = try imageFile.getData()
                    card.image = imageData
                } catch {
                    //
                }

                card.title = String(cards![index]["title"])
                card.desc = String(cards![index]["desc"])
                card.addTime = NSDate()
                
                self.appDelegate.saveContext()
                
                // reload local cards from core data
                self.refreshLocalResults()
                // move to first page
                self.initPage()
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    // get 1 random number
    func random1Number(total: Int) -> Int {
        let number = Int(arc4random_uniform(UInt32(total)))
        return number
    }
    
    // move to first page
    func initPage() {
        let firstContentViewController: PageContentViewController = self.viewControllerAtIndex(0)!
        let vcArray = [firstContentViewController]
        self.pageViewController?.setViewControllers(vcArray, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    
    
    
    
    
    


}

