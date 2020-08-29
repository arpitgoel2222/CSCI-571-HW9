//
//  article.swift
//  HW9
//
//  Created by ARPIT on 4/13/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import Foundation
import UIKit

class article{
    var image: String
    var title: String
    var time: String
    var section: String
    var articleid: String
    var url : String
    
    init(image:String,title:String,time:String,section:String,articleid:String,url:String) {
        self.image=image
        self.title=title
        self.time=time
        self.articleid=articleid
        self.section=section
        self.url = url
    }
}
