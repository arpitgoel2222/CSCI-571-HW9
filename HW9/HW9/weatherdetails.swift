//
//  weatherdetails.swift
//  HW9
//
//  Created by ARPIT on 4/18/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import Foundation
import UIKit

class weatherdetails{
var image: UIImage
var city: String
var temp: String
var state: String
var type: String

init(image:UIImage,city:String,state:String,temp:String,type:String) {
    self.image=image
    self.type=type
    self.temp=temp
    self.city=city
    self.state=state
}
}
