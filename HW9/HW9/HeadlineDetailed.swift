//
//  HeadlineDetailed.swift
//  HW9
//
//  Created by ARPIT on 4/20/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner


var detail5 : [detailedinfo] = []



class HeadlineDetailed: UIViewController {
    
    @IBAction func openlink(_ sender: Any) {
        print("button tapped")
        UIApplication.shared.open(NSURL(string: detail5[0].url)! as URL)
    }
    
    @IBOutlet weak var HDSection: UILabel!
    @IBOutlet weak var HDDesc: UILabel!
    @IBOutlet weak var HDDate: UILabel!
    @IBOutlet weak var HDTitle: UILabel!
    @IBOutlet weak var HDScroll: UIScrollView!
    @IBOutlet weak var HDImage: UIImageView!
    var articleid = ""
    var id  = ""
    var titlenav = ""
    var count:Int = 0
    func addBackButton() {
       
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal) // Image can be downloaded from here below link
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        let twitter = UIButton(type: .custom)
        twitter.setTitleColor(.systemBlue, for: .normal) // You can change the TitleColor
        
        twitter.tintColor = .systemBlue
        twitter.setImage(UIImage(named: "twitter"), for: .normal)
        
        twitter.setImage(UIImage(named: "twitter")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)

        twitter.addTarget(self, action: #selector(self.opentwitter(_:)), for: .touchUpInside)
        
        
        let bookmark = UIButton(type: .custom)
        bookmark.setTitleColor(bookmark.tintColor, for: .normal) // You can change the TitleColor
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmark")
        //print(data)
        var f = false
        for x in JSON(data){
            
            if(x.1["id"].stringValue == id)
            {
                f = true
                break;
            }
            
        }
        if( f == true)
        {
            bookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
           
        }
        else{
              bookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        bookmark.addTarget(self, action: #selector(self.add(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: twitter),UIBarButtonItem(customView: bookmark)]
        
        
        self.title = titlenav
        
    }
    @IBAction func opentwitter(_ sender: Any) {
        
        
        let textString = detail5[0].url + "#CSCI_571_NewsApp"
        let tweetUrl = title
        
        let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        //UIApplication.shared.openURL(url!)
        UIApplication.shared.open(url!)
    }
    
    @IBAction func add(_ sender: Any) {
        
        let userdefaults = UserDefaults.standard
        var data = userdefaults.array(forKey: "bookmark")
        
            if(data?.count == 0 || data == nil )
            {
                 self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                var data2  = [
                   "id" : id,
                   "image" :detail5[0].image,
                    "section" :detail5[0].section,
                    "date": detail5[0].date,
                    "title": detail5[0].title
                ]
                userdefaults.set([data2], forKey: "bookmark")
                let btnImage = UIImage(systemName: "bookmark.fill")
                (sender as AnyObject).setImage(btnImage , for: .normal)
                userdefaults.synchronize()
               
                
               
            }
            
            else{
                var data2  = [
                   "id" : id,
                   "image" :detail5[0].image,
                    "section" :detail5[0].section,
                    "date": detail5[0].date,
                    "title": detail5[0].title
                ]
                var flag  = false
                var i = 0
                for datas in JSON(data)
                {
                    if(data2["id"] == datas.1["id"].string!)
                    {
                        flag = true
                        break;
                    }
                    else{
                        i = i + 1
                    }
                }
                if(flag)
                {
                    //print("in flag")
                    self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
                    data!.remove(at: i)
                    let btnImage = UIImage(systemName: "bookmark")
                    (sender as AnyObject).setImage(btnImage , for: .normal)
                   
                  

                }
                else{
                    data!.append(data2)
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                    let btnImage = UIImage(systemName: "bookmark.fill")
                    (sender as AnyObject).setImage(btnImage , for: .normal)
                    
                  
                }
                userdefaults.set(data, forKey: "bookmark")
                userdefaults.synchronize()
        
        
       
        }
    }
    
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    HDScroll.contentSize = CGSize(width: 414, height: 1100)
        if(count == 0)
        {        SwiftSpinner.show("Loading Detailed article..")

            count = count+1
        }
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        let _ = self.dismiss(animated: true, completion: nil)
    }
        override func viewDidLoad() {
        
        //var data  = String()
        super.viewDidLoad()
           
         addBackButton()
            if(detail5.count==0)
                
          { print("vbfjvbf")
            //SwiftSpinner.show("loading detailed page")}
            view.addSubview(HDScroll)}

            let params = ["id":articleid]
            AF.request("https://nodeiosapp.wl.r.appspot.com/create", parameters: params)
                .responseJSON{
                    response in switch response.result{
                        
                    case .success(let value):
                        let json = JSON(value)
                        //SwiftSpinner.show("Loading Detailed page..")
                        //debugPrint(json)
                        let title = json["webTitle"].stringValue
                        
                        let section = json["sectionName"].stringValue
                        let date = json["webPublicationDate"].stringValue
                        var date11 = json["webPublicationDate"].stringValue
                        
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = " dd MMM yyyy"  //"MMM d, h:mm a" for  Sep 12, 2:11 PM
                        let datee = dateFormatterGet.date(from: date11)
                        date11 =  dateFormatterPrint.string(from: datee ?? Date())
                        let pageurl = json["webUrl"].stringValue
                        
                        let description = json["blocks"]["body"]
                        var i = 0
                        var desc = ""
                        while(i<description.count)
                        {
                            desc = desc + description[i]["bodyHtml"].stringValue
                            i = i+1
                        }
                        
                        
                        var descconverted = desc.html2String
                        //print(descconverted)
                        
                      
                        
                        
                        //debugPrint(desc)
                        let pivot = json["blocks"]["main"]["elements"][0]["assets"]
                        //debugPrint(json[i]["blocks"]["main"])
                        let image = pivot[pivot.count-1]["file"].stringValue
                        //print(image)
                        let detail2 = detailedinfo(image:image,title:title,date:date,section:section, description: desc,url:pageurl)
                        detail5.append(detail2)
                         SwiftSpinner.hide()
                        self.HDTitle.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                        self.HDTitle.numberOfLines = 0
                        self.HDTitle.text = title
                        let url1 = NSURL(string:image)
                        //debugPrint(url1)
                        let imagedata = NSData.init(contentsOf: url1! as URL)
                        
                        if imagedata != nil {
                            self.HDImage.image = UIImage(data:imagedata! as Data)
                        }
                        else{
                            self.HDImage.image = UIImage(named: "default-guardian")
                        }
                        self.HDDesc.numberOfLines = 30
                        self.HDDesc.lineBreakMode = .byTruncatingTail
                        self.HDDesc.text = descconverted
                        self.HDSection.text = date11
                        self.HDDate.text = section
                         
                        //self.urlbutton.addTarget(self, action: Selector(("openurl")), for: .touchUpInside)

                        func openurl(_ sender: Any) {
                            
                            UIApplication.shared.open(NSURL(string: detail5[0].url)! as URL)
                        }
                       
                            print(self.navigationController?.navigationItem.rightBarButtonItem)
                        
                          
                        
                        
                    case .failure(let error):
                        print(error)
                    }

        
    }
}



   
}
