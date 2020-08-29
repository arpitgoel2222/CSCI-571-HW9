
import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON


var hid = [String]()
var hdate = [String]()
class HeadlineSearch: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var data = String()
    var article1 : [article] = []
    override func viewWillAppear(_ animated: Bool)
       {
           super.viewWillAppear(animated)

           self.tableView.reloadData()
       }
    @objc func refresh(sender:AnyObject) {
                   let params = ["id":data]
                   AF.request("https://nodeiosapp.wl.r.appspot.com/searchq", parameters: params)
                   .responseJSON{
                       response in switch response.result{
                       case .success(let value):
                           let json = JSON(value)["guardian"]
                           //debugPrint(json)
                           self.article1=[]
                           var i = 0
                          while(i<json.count){
                               let title1 = json[i]["webTitle"].stringValue
                               var time = json[i]["webPublicationDate"].stringValue
                            hdate.append(time)
                           let relativeDtf = RelativeDateTimeFormatter()
                                             let dateFormatter = ISO8601DateFormatter()
                                             let webDate = dateFormatter.date(from:time)!
                                             let now = Date()
                                             var diff = relativeDtf.localizedString(for: webDate , relativeTo: now)
                              var ind =  Int(String(diff[diff.startIndex]))!
                                             let components = Calendar.current.dateComponents(
                                                 [.day, .year, .month, .hour,.minute, .second],
                                                 from: webDate,
                                                 to: now
                                             )
                                         var hrs:Int = 0
                                         var thrs : String = ""
                                         if(diff.contains("second"))
                                         {
                                             hrs = components.second!
                                             thrs = String(hrs) + "s ago"
                                         }
                                         else if(diff.contains("minutes") || diff.contains("minute") )
                                         {
                                             hrs = components.minute!
                                             thrs = String(hrs) + "m ago"
                                         }
                                         else if(diff.contains("hour") || diff.contains("hours"))
                                         {
                                             hrs = components.hour!
                                             thrs = String(hrs) + "h ago"
                                         }
                                         if(diff.contains("days") || diff.contains("day"))
                                         {
                                             hrs = components.day! * 24 +  components.hour!
                                         }
                                         if(diff.contains("weeks") || diff.contains("week"))
                                         {
           hrs  =  components.day! * 24 + components.hour!
                                         }
                                         if(diff.contains("months") || diff.contains("month"))
                                         {
                                              hrs = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                         }
                                         if(diff.contains("year"))
                                         {
                                             hrs  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                         }
                                         thrs  = String(hrs) + "h ago"
                                         
                               let sectionname="| " + json[i]["sectionName"].stringValue
                               let articleid=json[i]["id"].stringValue
                               let pivot = json[i]["blocks"]["main"]["elements"][0]["assets"]
                               //debugPrint(pivot[pivot.count-1])
                               let image = pivot[pivot.count-1]["file"].stringValue
                               let url  = json[i]["webUrl"].stringValue
                           let article2 = article(image:image,title:title1,time:thrs,section:sectionname,articleid:articleid,url:url)
                           
                               self.article1.append(article2)
                              
                           
                               hid.append(json[i]["id"].stringValue)
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
   
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Search results..")
        refreshControl = UIRefreshControl()
               refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
               tableView.addSubview(refreshControl)
        
        
        
        //print(data)
        self.article1=[]
        let params = ["id":data]
        AF.request("https://nodeiosapp.wl.r.appspot.com/searchq", parameters: params)
        .responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)["guardian"]
                //debugPrint(json)
                
                var i = 0
               while(i<json.count){
                    let title1 = json[i]["webTitle"].stringValue
                    var time = json[i]["webPublicationDate"].stringValue
                let relativeDtf = RelativeDateTimeFormatter()
                                  let dateFormatter = ISO8601DateFormatter()
                                  let webDate = dateFormatter.date(from:time)!
                                  let now = Date()
                 hdate.append(time)
                                  var diff = relativeDtf.localizedString(for: webDate , relativeTo: now)
                   var ind =  Int(String(diff[diff.startIndex]))!
                                  let components = Calendar.current.dateComponents(
                                      [.day, .year, .month, .hour,.minute, .second],
                                      from: webDate,
                                      to: now
                                  )
                              var hrs:Int = 0
                              var thrs : String = ""
                              if(diff.contains("second"))
                              {
                                  hrs = components.second!
                                  thrs = String(hrs) + "s ago"
                              }
                              else if(diff.contains("minutes") || diff.contains("minute") )
                              {
                                  hrs = components.minute!
                                  thrs = String(hrs) + "m ago"
                              }
                              else if(diff.contains("hour") || diff.contains("hours"))
                              {
                                  hrs = components.hour!
                                  thrs = String(hrs) + "h ago"
                              }
                              if(diff.contains("days") || diff.contains("day"))
                              {
                                  hrs = components.day! * 24 +  components.hour!
                              }
                              if(diff.contains("weeks") || diff.contains("week"))
                              {
hrs  =  components.day! * 24 + components.hour!
                              }
                              if(diff.contains("months") || diff.contains("month"))
                              {
                                   hrs = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                              }
                              if(diff.contains("year"))
                              {
                                  hrs  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                              }
                              thrs  = String(hrs) + "h ago"
                              
                    let sectionname="| " + json[i]["sectionName"].stringValue
                    let articleid=json[i]["id"].stringValue
                    let pivot = json[i]["blocks"]["main"]["elements"][0]["assets"]
                    //debugPrint(pivot[pivot.count-1])
                    let image = pivot[pivot.count-1]["file"].stringValue
                    let url  = json[i]["webUrl"].stringValue
                let article2 = article(image:image,title:title1,time:thrs,section:sectionname,articleid:articleid,url:url)
                
                    self.article1.append(article2)
                   
                
                    hid.append(json[i]["id"].stringValue)
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
        tableView.delegate=self
        tableView.dataSource=self
        
        
    }}


extension HeadlineSearch: UITableViewDataSource, UITableViewDelegate{
    
    
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
                                            "date": hdate[indexPath.row],
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
                                            "date": hdate[indexPath.row],
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

              print("row: \(indexPath.row)")
              let row = indexPath.row
              indexselected = row
              performSegue(withIdentifier: "hsd", sender: self)
              //performSegue(withIdentifier: "showdetail", sender: self)
              

          
      
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "hsd" {
              
              
              if(segue.destination.isKind(of: HSD.self))

              {
                
                  let secondVC = segue.destination as! HSD

                  //let indexPath = sender as! IndexPath
                  //debugPrint(indexselected)
                  secondVC.data = aid[indexselected]
                 secondVC.id = article1[indexselected].articleid
                  secondVC.titlenav = article1[indexselected].title
                
              }
          }
      }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchR") as! SearchR
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.borderWidth = 0.5

        cell.HeadlineBookmark.tag = indexPath.row
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
            cell.HeadlineBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
        }
        else{
             cell.HeadlineBookmark.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
        }
        cell.HeadlineBookmark.addTarget(self, action: #selector(add), for: UIControl.Event.touchUpInside)
        //cell.ArticleImage.image=UIImage(named: "clear_weather")
//        cell.setitem(article1: video)
        cell.HeadlineTitle.text = article1[indexPath.row].title
        cell.HeadlineTime.text = article1[indexPath.row].time
        cell.HeadlineSection.text = article1[indexPath.row].section
            
        
           let url = NSURL(string:article1[indexPath.row].image)
               let imagedata = NSData.init(contentsOf: url! as URL)

           if imagedata != nil {
               cell.HeadlineImage.image = UIImage(data:imagedata! as Data)
           }
        else{
            cell.HeadlineImage.image = UIImage(named:"default-guardian" )
        }
        
           
                        
            return cell
    }
    
    @objc func add(sender:UIButton){
           let rownumber = sender.tag
           
           let userdefaults = UserDefaults.standard
           var data = userdefaults.array(forKey: "bookmark")
           
               if(data?.count == 0 || data == nil )
               {
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                   var data2  = [
                       "id" : self.article1[rownumber].articleid,
                       "image" :self.article1[rownumber].image,
                       "section" : self.article1[rownumber].section,
                       "date": hdate[rownumber],
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
                       "date": hdate[rownumber],
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

