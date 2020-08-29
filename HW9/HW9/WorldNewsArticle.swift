//
//  WorldNewsArticle.swift
//  HW9
//
//  Created by ARPIT on 4/17/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit

class WorldNewsArticle: UITableViewCell {
   
  
    @IBOutlet weak var WorldTime: UILabel!
    
    @IBOutlet weak var WorldSection: UILabel!
    @IBOutlet weak var WorldImage: UIImageView!
    
    @IBOutlet weak var WorldTitle: UILabel!
    
    @IBOutlet weak var BookmarkButton: UIButton!
    
     override func layoutSubviews() {
            super.layoutSubviews()
    //        Title.textContainer.maximumNumberOfLines = 3;
    //        Title.textContainer.lineBreakMode = .byTruncatingTail;
            //Title.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }
    
    
    
}
