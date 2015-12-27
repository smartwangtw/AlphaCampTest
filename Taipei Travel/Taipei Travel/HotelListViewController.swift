//
//  HotelListViewController.swift
//  Taipei Travel
//
//  Created by WANGMING-LIANG on 12/27/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HotelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var hotels: [Hotel] = []
    var loadCount: Int = 10
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData(loadCount, offset: 0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "resetData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath: \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(hotels[indexPath.row].no!). \(hotels[indexPath.row].name!)"
        cell.detailTextLabel?.text = hotels[indexPath.row].address
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("willDisplayCell: \(indexPath.row)")
        
        if indexPath.row == hotels.count - 1 {
            loadData(loadCount, offset: hotels.count)
        }
    }
    
    
    // Mark: private method
    // Restart load data
    func loadData(rows: Int, offset: Int) {
        let url: String = "http://data.taipei/opendata/datalist/apiAccess"
        
        Alamofire.request(.GET, url, parameters: ["scope": "resourceAquire",
            "rid": "6f4e0b9b-8cb1-4b1d-a5c4-febd90f62469",
            "limit": "\(rows)",
            "offset": "\(offset)"])
            .responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    let hotelList = json["result"]["results"].arrayValue
                    
                    for hotelData in hotelList {
                        let hotel: Hotel = Hotel()
                        hotel.no = hotelData["RowNumber"].intValue
                        hotel.name = hotelData["stitle"].stringValue
                        hotel.address = hotelData["address"].stringValue
                        
                        self.hotels.append(hotel)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    
                }
        }

    }
    
    func resetData(sender: AnyObject) {
        hotels.removeAll()
        self.tableView.reloadData()
        
        loadData(loadCount, offset: 0)

        self.refreshControl.endRefreshing()
    }
    
    class Hotel {
        var no: Int?
        var name: String?
        var address: String?
    }

}
