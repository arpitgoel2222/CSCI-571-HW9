//
//  SearchR.swift
//  HW9
//
//  Created by ARPIT on 4/20/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit

class SearchR: UITableViewCell {
    
    @IBOutlet weak var SearchSection: UILabel!
       @IBOutlet weak var SearchTime: UILabel!
       @IBOutlet weak var SearchTitle: UILabel!
       @IBOutlet weak var SearchImage: UIImageView!

    @IBOutlet weak var HomeBookmark: UIButton!
    
    @IBOutlet weak var HeadlineTime: UILabel!
    
    @IBOutlet weak var HeadlineImage: UIImageView!
    
    @IBOutlet weak var HeadlineTitle: UILabel!
    
    @IBOutlet weak var HeadlineSection: UILabel!
    
    @IBOutlet weak var HeadlineBookmark: UIButton!
    
    override func layoutSubviews() {
           super.layoutSubviews()
           contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
       }
    
}
