//
//  TravelListTableViewController.swift
//  Taipei Travel
//
//  Created by WANGMING-LIANG on 12/26/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TravelListTableViewController: UITableViewController {
    var hotels: [Hotel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        reloadData(5, offset: 5)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = hotels[indexPath.row].name
        cell.detailTextLabel?.text = hotels[indexPath.row].address

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Mark: private method
    // Restart load data
    func reloadData(rows: Int, offset: Int) {
        let url: String = "http://data.taipei/opendata/datalist/apiAccess"
        
        Alamofire.request(.GET, url, parameters: ["scope": "resourceAquire",
            "rid": "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469",
            "limit": "\(rows)",
            "offset": "\(offset)"])
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let data = response.result.value {
                    let json = JSON(data)
                    print(json)
                    
                    let hotelList = json["result"]["results"].arrayValue
                    
                    for hotelData in hotelList {
                        let hotel: Hotel = Hotel()
                        hotel.name = hotelData["stitle"].stringValue
                        hotel.address = hotelData["address"].stringValue
                        
                        self.hotels.append(hotel)
                    }
                    
                    
                    

                }
        }
    }
    
    class Hotel {
        var name: String?
        var address: String?
    }

}
