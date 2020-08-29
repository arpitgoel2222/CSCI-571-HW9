//
//  Child5ViewController.swift
//  HW9
//
//  Created by ARPIT on 4/17/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//
import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import SwiftSpinner


class Child5ViewController: UIViewController, IndicatorInfoProvider {
        
        var refreshControl = UIRefreshControl()
        var article1 : [article] = []
        var image = [String]()
        var webtitle = [String]()
        var time5 = [String]()
        var section = [String]()
        var articleid = [String]()
        
    @IBOutlet weak var tableView: UITableView!
    
        func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: "TECHNOLOGY")
        }
    @objc func refresh(sender:AnyObject) {
         AF.request("https://nodeiosapp.wl.r.appspot.com/guardiant")
                       
                       .responseJSON{
                       response in switch response.result{
                       case .success(let value):
                           let json = JSON(value)
                           self.article1=[]
                           //debugPrint(json)
           //                let currentDateTime = Date()
           //                debugPrint(currentDateTime)
                           var i = 0
                           while(i<json.count){
                               let title1 = json[i]["webTitle"].stringValue

                               var time = json[i]["webPublicationDate"].stringValue
                            self.time5.append(time)
                               let relativeDtf = RelativeDateTimeFormatter()
                                   let dateFormatter = ISO8601DateFormatter()
                                   let webDate = dateFormatter.date(from:time)!
                                   let now = Date()
                                   var diff = relativeDtf.localizedString(for: webDate , relativeTo: now)
                                   
                                   
                                   let components = Calendar.current.dateComponents(
                                       [.day, .year, .month, .hour,.minute, .second],
                                       from: webDate,
                                       to: now
                                   )
                               var finaltime:Int = 0
                               var t1: String = ""
                              if(diff.contains("seconds"))
                                                           {
                                                               finaltime = components.second!
                                                               t1 = String(finaltime) + "s ago"
                                                           }
                                                           else if(diff.contains("minutes") || diff.contains("minute") )
                                                           {
                                                               finaltime = components.minute!
                                                               t1 = String(finaltime) + "m ago"
                                                           }
                                                           else if(diff.contains("hour") || diff.contains("hours"))
                                                           {
                                                               finaltime = components.hour!
                                                                                      t1 = String(finaltime) + "h ago"
                                                           }
                               
                                                           else{
                                                              if(diff.contains("days") || diff.contains("day"))
                                                               {
                                                                   finaltime = components.day! * 24 +  components.hour!
                                                                   t1 = String(finaltime) + "h ago"
                                                               }
                                                               else if(diff.contains("months") || diff.contains("month"))
                                                                                   {
                                                                                        finaltime = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                                                       t1 = String(finaltime) + "h ago"
                                                                                   }
                                                                else if(diff.contains("year"))
                                                                                   {
                                                                                       finaltime  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                                                       t1 = String(finaltime) + "h ago"
                                                                                   }
                                else{
                                                                finaltime = components.day! * 24 + components.hour!
                                                                t1 = String(finaltime) + "h ago"
                                }
                                                               
                                                           }
                                                           
                               
                               
                               
                               let sectionname="| " + json[i]["sectionName"].stringValue
                               //debugPrint(sectionname)
                               let articleid=json[i]["id"].stringValue
                               let pivot = json[i]["blocks"]["main"]["elements"][0]["assets"]
                               debugPrint(pivot[pivot.count-1])
                               let image = pivot[pivot.count-1]["file"].stringValue
                               let url = json[i]["webUrl"].stringValue
                               //debugPrint(image)
                               let article2 = article(image:image,title:title1,time:t1,section:sectionname,articleid:articleid,url:url)
                               self.article1.append(article2)
                               //self.article1[i].image.append(pivot["thumbnail"].stringValue)
                               i=i+1
                           }
                           DispatchQueue.main.async {
                               
                               self.tableView.reloadData()
                          
                               
                               
                           }
                           
                       case .failure(let error):
                           print(error)
                       }
                       
                       
                   }
           self.refreshControl.endRefreshing()
       }
    
    override func viewWillAppear(_ animated: Bool)
       {
           super.viewWillAppear(animated)

           self.tableView.reloadData()
       }
        

        override func viewDidLoad() {
            super.viewDidLoad()
            SwiftSpinner.show("Loading TECHNOLOGY Headlines.. ")
            refreshControl = UIRefreshControl()
                   refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
                   tableView.addSubview(refreshControl)
            article1=[]
            
            AF.request("https://nodeiosapp.wl.r.appspot.com/guardiant")
                        
                        .responseJSON{
                        response in switch response.result{
                        case .success(let value):
                            let json = JSON(value)
                            //debugPrint(json)
            //                let currentDateTime = Date()
            //                debugPrint(currentDateTime)
                            var i = 0
                            while(i<json.count){
                                let title1 = json[i]["webTitle"].stringValue

                                var time = json[i]["webPublicationDate"].stringValue
                                let relativeDtf = RelativeDateTimeFormatter()
                                    let dateFormatter = ISO8601DateFormatter()
                                    let webDate = dateFormatter.date(from:time)!
                                    let now = Date()
                                self.time5.append(time)
                                    var diff = relativeDtf.localizedString(for: webDate , relativeTo: now)
                                    
                                    
                                    let components = Calendar.current.dateComponents(
                                        [.day, .year, .month, .hour,.minute, .second],
                                        from: webDate,
                                        to: now
                                    )
                                var finaltime:Int = 0
                                var t1: String = ""
                               if(diff.contains("seconds"))
                                                            {
                                                                finaltime = components.second!
                                                                t1 = String(finaltime) + "s ago"
                                                            }
                                                            else if(diff.contains("minutes") || diff.contains("minute") )
                                                            {
                                                                finaltime = components.minute!
                                                                t1 = String(finaltime) + "m ago"
                                                            }
                                                            else if(diff.contains("hour") || diff.contains("hours"))
                                                            {
                                                                finaltime = components.hour!
                                                                                       t1 = String(finaltime) + "h ago"
                                                            }
                                
                                                            else{
                                                               if(diff.contains("days") || diff.contains("day"))
                                                                {
                                                                    finaltime = components.day! * 24 +  components.hour!
                                                                    t1 = String(finaltime) + "h ago"
                                                                }
                                                                else if(diff.contains("months") || diff.contains("month"))
                                                                                    {
                                                                                         finaltime = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                                                        t1 = String(finaltime) + "h ago"
                                                                                    }
                                                                 else if(diff.contains("year"))
                                                                                    {
                                                                                        finaltime  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                                                        t1 = String(finaltime) + "h ago"
                                                                                    }
                                else{
                                                                finaltime = components.day! * 24 + components.hour!
                                                                t1 = String(finaltime) + "h ago"
                                }
                                                                
                                                            }
                                                            
                                
                                
                                
                                let sectionname="| " + json[i]["sectionName"].stringValue
                                //debugPrint(sectionname)
                                let articleid=json[i]["id"].stringValue
                                let pivot = json[i]["blocks"]["main"]["elements"][0]["assets"]
                                debugPrint(pivot[pivot.count-1])
                                let image = pivot[pivot.count-1]["file"].stringValue
                                let url = json[i]["webUrl"].stringValue
                                //debugPrint(image)
                                let article2 = article(image:image,title:title1,time:t1,section:sectionname,articleid:articleid,url:url)
                                self.article1.append(article2)
                                //self.article1[i].image.append(pivot["thumbnail"].stringValue)
                                i=i+1
                            }
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                SwiftSpinner.hide()
                                
                                
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                        
                        
                    }
                    //debugPrint(type(of: time))
                    //article1 = createArray(time:time,t:webtitle)
                    tableView.delegate=self
                    tableView.dataSource=self
            

        }

    }


    extension Child5ViewController: UITableViewDataSource, UITableViewDelegate{
        
        
        func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            
            
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                    let textString = self.article1[indexPath.row].url + "#CSCI_571_NewsApp"
                    let tweetUrl = self.article1[indexPath.row].title
                    
                    let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
                    
                    // encode a space to %20 for example
                    let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    // cast to an url
                    let url = URL(string: escapedShareString)
                    
                    // open in safari
                    //UIApplication.shared.openURL(url!)
                    UIApplication.shared.open(url!)
                }
                let userdefaults = UserDefaults.standard
                                      var data = userdefaults.array(forKey: "bookmark")
                                      var flag  = false
                                      var i = 0
                                      var contextmenuimage:UIImage
                                      for datas in JSON(data)
                                      {
                                          //print(datas.1["id"].string)
                                          //print(self.article1[indexPath.row].articleid)
                                          if(self.article1[indexPath.row].articleid == datas.1["id"].string!)
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

                                          contextmenuimage = UIImage(systemName: "bookmark.fill")!
                                      }
                                      else{
                                          contextmenuimage = UIImage(systemName: "bookmark")!
                                      }
                                      //print(contextmenuimage)
                           let bookmark = UIAction(title: "Bookmark",image:contextmenuimage,  identifier: nil) { action in
                        let userdefaults = UserDefaults.standard
                                    var data = userdefaults.array(forKey: "bookmark")
                                    
                                        if(data?.count == 0 || data == nil )
                                        {
                                             self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                                            var data2  = [
                                                "id" : self.article1[indexPath.row].articleid,
                                               "image" :self.article1[indexPath.row].image,
                                                "section" :self.article1[indexPath.row].section,
                                                "date": self.time5[indexPath.row],
                                                "title": self.article1[indexPath.row].title,
                                                "url" : self.article1[indexPath.row].url
                                            ]
                                            userdefaults.set([data2], forKey: "bookmark")
                                            
                                            userdefaults.synchronize()
                                           let delay = 0.4
                                                              DispatchQueue.main.asyncAfter(deadline: .now() + delay )
                                                              {
                                                                  self.tableView.performBatchUpdates({
                                                                   self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                                                  })
                                           }}
                                        
                                        else{
                                            var data2  = [
                                                "id" : self.article1[indexPath.row].articleid,
                                               "image" :self.article1[indexPath.row].image,
                                                "section" :self.article1[indexPath.row].section,
                                                "date": self.time5[indexPath.row],
                                                "title": self.article1[indexPath.row].title,
                                                "url" : self.article1[indexPath.row].url
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
                                               //bookmark.image = UIImage(systemName: "bookmark")
                                                

                                            }
                                            else{
                                                data!.append(data2)
                                                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                                               //bookmark.image = UIImage(systemName: "bookmark.fill")

                                            }
                                            userdefaults.set(data, forKey: "bookmark")
                                            userdefaults.synchronize()
                                            let delay = 0.4
                                                               DispatchQueue.main.asyncAfter(deadline: .now() + delay )
                                                               {
                                                                   self.tableView.performBatchUpdates({
                                                                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                                                   })
                                            }}}
                
                let edit = UIMenu(__title: "Edit", image: nil, identifier: nil, children:[twitter,bookmark])
                return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
            }
            return configuration
        }
        
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return article1.count
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

                    //print("row: \(indexPath.row)")
        //            let row = indexPath.row
        //            indexselected = row
        //            performSegue(withIdentifier: "showsa", sender: self)
        //            //performSegue(withIdentifier: "showdetail", sender: self)
                    
                    
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let VC1 = story.instantiateViewController(withIdentifier: "HeadlineDetailed") as! HeadlineDetailed
                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
                    navController.modalPresentationStyle = .fullScreen
                    VC1.articleid = self.article1[indexPath.row].articleid
                    VC1.titlenav =  self.article1[indexPath.row].title
            VC1.id = self.article1[indexPath.row].articleid
                    
                    
                    self.present(navController, animated:true, completion: nil)
                    
                    

                
            
            }
        

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
                func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                    return 10; // space b/w cells
                    
            }
                
            
            //let video = article1[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TechnologyNewsArticle") as! TechnologyNewsArticle
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell.contentView.layer.borderWidth = 0.5

            cell.BookmarkButton.tag = indexPath.row
            var bdata = UserDefaults.standard.array(forKey: "bookmark")
            //print(bdata)
            var f = false
            for x in JSON(bdata){
                
                if(x.1["id"].stringValue == self.article1[indexPath.row].articleid)
                {
                    f = true
                    break;
                }
                
            }
            if( f == true)
            {
                cell.BookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
            }
            else{
                 cell.BookmarkButton.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
            }
            cell.BookmarkButton.addTarget(self, action: #selector(add), for: UIControl.Event.touchUpInside)
            //cell.ArticleImage.image=UIImage(named: "clear_weather")
    //        cell.setitem(article1: video)
            cell.TTitle.text = article1[indexPath.row].title
            cell.TTime.text = article1[indexPath.row].time
            cell.TSection.text = article1[indexPath.row].section
                
            
               let url = NSURL(string:article1[indexPath.row].image)
                   let imagedata = NSData.init(contentsOf: url! as URL)

               if imagedata != nil {
                   cell.TImage.image = UIImage(data:imagedata! as Data)
               }
            else{
                cell.TImage.image = UIImage(named: "default-guardian")
            }
                            
                return cell
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
                        "id" : self.article1[rownumber].articleid,
                        "image" :self.article1[rownumber].image,
                        "section" : self.article1[rownumber].section,
                        "date": time5[rownumber],
                        "title": self.article1[rownumber].title,
                        "url" : self.article1[rownumber].url
                    ]
                    userdefaults.set([data2], forKey: "bookmark")
                    
                    userdefaults.synchronize()
                    
                    self.tableView.reloadData()
                }
                
                else{
                    var data2  = [
                        "id" : self.article1[rownumber].articleid,
                        "image" :self.article1[rownumber].image,
                        "section" : self.article1[rownumber].section,
                        "date": time5[rownumber],
                        "title": self.article1[rownumber].title,
                        "url" : self.article1[rownumber].url
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

                    }
                    else{
                        data!.append(data2)
                        self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)

                    }
                    userdefaults.set(data, forKey: "bookmark")
                    userdefaults.synchronize()
                    self.tableView.reloadData()
                    
            }
            
        }
        
    }

