//
//  ChartController.swift
//  HW9
//
//  Created by ARPIT on 4/16/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON


var keyword:String = "Coronavirus"

class ViewController: UIViewController {
    
    @IBOutlet weak var linechart: LineChartView!
    @IBOutlet weak var searchtextfield: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        searchtextfield.addTarget(self, action: #selector(textFieldDidChange2(textField:)), for: UIControl.Event.editingDidEndOnExit)
        
        linechart.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        linechart.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        linechart.layer.borderWidth = 1
        
        var parameters = ["term": keyword.lowercased() ]
    AF.request("https://nodeiosapp.wl.r.appspot.com/",parameters: parameters).responseJSON{
       response in switch response.result{
        case .success(let value):
        let json = JSON(value)
        var value = [Int]()
             var i=0
             while(i<json.count){
                let valuedata = json[i]["value"][0].stringValue
                let myInt = Int(valuedata)!
                value.append(myInt)
                i=i+1
                
        }
        var dataEntry = [ChartDataEntry]()
        
        for i in 0 ..< value.count {
            let minT = ChartDataEntry(x: Double(i), y: Double(value[i]))
            dataEntry.append(minT)
        }
        var label1 = "Trending Charts for " + keyword
        let plotData = LineChartData()
        let lineMin = LineChartDataSet(entries: dataEntry, label: label1)
        lineMin.colors = [NSUIColor.systemBlue]
        lineMin.circleHoleColor = NSUIColor.systemBlue
        lineMin.circleColors = [NSUIColor.systemBlue]
        lineMin.circleRadius = 4.0
        plotData.addDataSet(lineMin)
        self.linechart.data = plotData
        
        case .failure(let error):
            print (error)}
        }

    }

    @objc func textFieldDidChange2(textField: UITextField){
        keyword  = searchtextfield.text!
        self.viewDidLoad()

       }

}
