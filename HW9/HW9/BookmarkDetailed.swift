//
//  BookmarkDetailed.swift
//  HW9
//
//  Created by ARPIT on 4/22/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import Toast_Swift


var detail6 : [detailedinfo] = []


class BookmarkDetailed: UIViewController {
    
    
    @IBAction func openlink(_ sender: Any) {
        print("button tapped")
        UIApplication.shared.open(NSURL(string: detail6[0].url)! as URL)
    }
    
    var data = String()
    var titlenav = String()
    var id  = String()
     var count:Int = 0
    override func willMove(toParent parent: UIViewController?) {
           navigationController?.navigationBar.prefersLargeTitles = true
       }
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = titlenav
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmark")
        //print(data)
        var f = false
        for x in JSON(data)
        {
            
            if(x.1["id"].stringValue == id)
            {
                f = true
                break;
            }
            
        }
        if( f == true)
        {
            bookmarkbutton.image = UIImage(systemName: "bookmark.fill")
           
        }
        else{
              bookmarkbutton.image = UIImage(systemName: "bookmark")
        }
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        BKScroll.contentSize = CGSize(width: 414, height: 1100)
        if(count == 0)
        {        SwiftSpinner.show("Loading Detailed article..")

            count = count+1
        }
        
    }
    
    
    @IBAction func opentwitter(_ sender: Any) {
        
        let textString = detail6[0].url + "#CSCI_571_NewsApp"
        let tweetUrl = title
        let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
              // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }
    
    @IBOutlet weak var bookmarkbutton: UIBarButtonItem!
    @IBOutlet weak var BKImage: UIImageView!
    @IBOutlet weak var BKScroll: UIScrollView!
   
    @IBOutlet weak var BKSection: UILabel!
    @IBOutlet weak var BKDesc: UILabel!
    @IBOutlet weak var BKTime: UILabel!
    @IBOutlet weak var BKTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SwiftSpinner.show("Loading Detailed page..")
        setupUI()
//        print(id)
//        print(titlenav)
//
        view.addSubview(BKScroll)
            
            
            let params = ["id":id]
            AF.request("https://nodeiosapp.wl.r.appspot.com/create", parameters: params)
                .responseJSON{
                    response in switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        //debugPrint(json)
                        let title = json["webTitle"].stringValue
                        
                        let section = json["sectionName"].stringValue
                        let date = json["webPublicationDate"].stringValue
                        var date11 = json["webPublicationDate"].stringValue
                        //id  = json["id"].stringValue
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
                        detail6.append(detail2)
                        
                        self.BKTitle.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                        self.BKTitle.numberOfLines = 0
                        self.BKTitle.text = title
                        let url1 = NSURL(string:image)
                        //debugPrint(url1)
                        let imagedata = NSData.init(contentsOf: url1! as URL)
                        
                        if imagedata != nil {
                            self.BKImage.image = UIImage(data:imagedata! as Data)
                        }
                        else{
                            self.BKImage.image = UIImage(named: "default-guardian")
                        }
                        self.BKDesc.numberOfLines = 30
                        self.BKDesc.lineBreakMode = .byTruncatingTail
                        self.BKDesc.text = descconverted
                        self.BKSection.text = section
                        self.BKTime.text = date11
                        self.bookmarkbutton.target = self;
                        self.bookmarkbutton.action = #selector(self.add);
                        //self.urlbutton.addTarget(self, action: Selector(("openurl")), for: .touchUpInside)

                        func openurl(_ sender: Any) {
                            
                            UIApplication.shared.open(NSURL(string: detail6[0].url)! as URL)
                        }

                        
                        
                        SwiftSpinner.hide()
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                    
            }
            
        }
    @objc func add(sender:UIButton){
            let rownumber = sender.tag
            //print(rownumber)
            let userdefaults = UserDefaults.standard
            var data = userdefaults.array(forKey: "bookmark")
            
                if(data?.count == 0 || data == nil )
                {
                     self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                    var data2  = [
                       "id" : id,
                       "image" :detail6[0].image,
                        "section" :detail6[0].section,
                        "date": detail6[0].date,
                        "title": detail6[0].title
                    ]
                    userdefaults.set([data2], forKey: "bookmark")
                    
                    userdefaults.synchronize()
                   bookmarkbutton.image = UIImage(systemName: "bookmark.fill")
                    
                   
                }
                
                else{
                    var data2  = [
                       "id" : id,
                       "image" :detail6[0].image,
                        "section" :detail6[0].section,
                        "date": detail6[0].date,
                        "title": detail6[0].title
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
                       bookmarkbutton.image = UIImage(systemName: "bookmark")

                    }
                    else{
                        data!.append(data2)
                        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                       bookmarkbutton.image = UIImage(systemName: "bookmark.fill")

                    }
                    userdefaults.set(data, forKey: "bookmark")
                    userdefaults.synchronize()
                   
                  
       
            }

        }

        
    }

    

   



