//
//  PageContentViewController.swift
//  Cards
//
//  Created by WANGMING-LIANG on 12/28/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit

// for display page content of 1 card
class PageContentViewController: UIViewController {
    @IBOutlet weak var imageViewCard: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    var pageIndex: Int = 0
    var cardTitle: String = ""
    var cardDesc: String = ""
    var cardImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        labelTitle.text = cardTitle
        labelDesc.text = cardDesc
        imageViewCard.image = cardImage
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
