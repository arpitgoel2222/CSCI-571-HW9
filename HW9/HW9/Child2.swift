//
//  Child2.swift
//  HW9
//
//  Created by ARPIT on 4/17/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//


import Foundation
import XLPagerTabStrip


class Child2: UIViewController,IndicatorInfoProvider{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BUSINESS")
    }
}
