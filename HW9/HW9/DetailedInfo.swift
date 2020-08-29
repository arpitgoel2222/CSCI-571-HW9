//
//  DetailedInfo.swift
//  HW9
//
//  Created by ARPIT on 4/18/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import Foundation
import UIKit

class detailedinfo{
    var image: String
    var title: String
    var date: String
    var section: String
    var description: String
    var url:String
    
    init(image:String,title:String,date:String,section:String,description:String,url:String) {
        self.image=image
        self.title=title
        self.date=date
        self.description=description
        self.section=section
        self.url=url
    }
}

