//
//  InitDataViewController.swift
//  Cards
//
//  Created by WANGMING-LIANG on 12/28/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//

import UIKit
import Parse

// Dummy class for uploading initial data to Parse
class InitDataViewController: UIViewController {
    let cardImageFiles: [String] = ["Cloth1", "Cloth2", "Cloth3", "Cloth4", "Pants1", "Shoes1", "Shoes2", "Skirt1", "Skirt2", "Skirt3"]
    let cardTitles: [String] = ["衣服1", "衣服2", "衣服3", "衣服4", "褲子1", "鞋子1", "鞋子2", "裙子1", "裙子2", "裙子3"]
    let cardDescs: [String] = ["粉紅上衣加黑色長袖", "甜甜圈加條紋長袖", "紫色上衣無袖", "暗藍色雙排扣加袖套", "黑色合身破洞長褲", "綠珠摟空高跟涼鞋", "甜甜圈平底鞋加橫紋長襪", "粉紅白花邊短裙", "綠紫色珠飾短裙", "紫短褲白裙邊配腰帶"]

    override func viewDidLoad() {
        super.viewDidLoad()

        for var index = 0; index < cardImageFiles.count; ++index {
            let cardObject = PFObject(className: "CardObject")
            cardObject["title"] = cardTitles[index]
            cardObject["desc"] = cardDescs[index]
            let imageData = UIImageJPEGRepresentation(UIImage(named: cardImageFiles[index])!, 0.1)
            let imageFile = PFFile(name:cardImageFiles[index], data:imageData!)
            cardObject["image"] = imageFile
            cardObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("\(index) Object has been saved.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
