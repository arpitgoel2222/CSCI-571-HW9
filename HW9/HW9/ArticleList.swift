//
//  ArticleList.swift
//  HW9
//
//  Created by ARPIT on 4/13/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreLocation
import Toast_Swift



var weather1 : [weatherdetails]? = []
var aid = [String]()
var indexselected:Int = 0
var searchkeywords = [String]()
var keys = [String]()
var keywordselected:String = ""
var date = [String]()
var filled = false

class ArticleList: UIViewController, CLLocationManagerDelegate,  UISearchBarDelegate{

    var refreshControl = UIRefreshControl()
    var article1 : [article] = []
    //var aid : [String]()

    var image = [String]()
    var webtitle = [String]()
    var time = [String]()
    var section = [String]()
    var articleid = [String]()
    var locationManager = CLLocationManager()

        
    @IBOutlet weak var autosuggest: UITableView!
    @IBOutlet weak var tableView:UITableView!
    
    
    @objc func refresh(sender:AnyObject) {
        
        //self.article1=[]
        //self.tableView.reloadData()
        AF.request("https://nodeiosapp.wl.r.appspot.com/guardian")
                    
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
                            date.append(time.components(separatedBy: "T")[0])
                            //print(time)
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
                           // print(components)
                            var finaltime:Int = 0
                            var t1  : String = ""
                            if(diff.contains("seconds"))
                            {
                                finaltime = components.second!
                                t1 = String(finaltime) + "s ago"
                            }
                            else if(diff.contains("minutes")  || diff.contains("minute")  )
                            {
                                finaltime = components.minute!
                                t1 = String(finaltime) + "m ago"
                            }
                            else if(diff.contains("hour") ||  diff.contains("hours") )
                            {
                                finaltime = components.hour!
                                                       t1 = String(finaltime) + "h ago"
                            }
                                
        //                    else if(diff.contains("weeks") || diff.contains("week"))
        //                                   {
        //                                    finaltime  = (diff.prefix(1) * 7 * 24 + components.day! * 24) + components.hour!
        //                                        t1 = String(finaltime) + "h ago"
        //                                   }
                                
                            else{
                               if(diff.contains("days") || diff.contains("day")  )
                                {
                                    finaltime = components.day! * 24 +  components.hour!
                                    t1 = String(finaltime) + "h ago"
                                }
                                
                                if(diff.contains("months") || diff.contains("month") )
                                                    {
                                                         finaltime = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                        t1 = String(finaltime) + "h ago"
                                                    }
                                 if(diff.contains("year"))
                                                    {
                                                        finaltime  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                        t1 = String(finaltime) + "h ago"
                                                    }
                                
                            }
                        

                            
                            
                            
                            
                            let sectionname="| " + json[i]["sectionName"].stringValue
                            let articleid=json[i]["id"].stringValue
                            let pivot = json[i]["fields"]
                            let image = pivot["thumbnail"].stringValue
                            let url = json[i]["webUrl"].stringValue
                 
                            let article2 = article(image:image,title:title1,time:t1,section:sectionname,articleid:articleid,url:url)
                            self.article1.append(article2)
                            //self.article1[i].image.append(pivot["thumbnail"].stringValue)
                            aid.append(json[i]["id"].stringValue)
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
    
//    @IBAction func bkmkbutton(_ sender: UIButton) {
//        debugPrint("gkjrgrhgkt")
//        let defaults = UserDefaults.standard
//        var data = defaults.array(forKey: "bookmarkData")
//        var indexselected = sender.tag-1
//        print(indexselected)
//
//    }
    
    @IBOutlet weak var Homenav: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
       
        self.tableView.reloadData()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        article1 = []
        autosuggest.isHidden = true
       
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search keyword..."
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        Homenav.searchController = searchController
        Homenav.hidesSearchBarWhenScrolling = true
        
        SwiftSpinner.show("Loading Home Page..")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
       

        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        
        
        
 AF.request("https://nodeiosapp.wl.r.appspot.com/guardian")
            
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
                    date.append(time.components(separatedBy: "T")[0])
                    //print(time)
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
                   // print(components)
                    var finaltime:Int = 0
                    var t1  : String = ""
                    if(diff.contains("seconds"))
                    {
                        finaltime = components.second!
                        t1 = String(finaltime) + "s ago"
                    }
                    else if(diff.contains("minutes")  || diff.contains("minute")  )
                    {
                        finaltime = components.minute!
                        t1 = String(finaltime) + "m ago"
                    }
                    else if(diff.contains("hour") ||  diff.contains("hours") )
                    {
                        finaltime = components.hour!
                                               t1 = String(finaltime) + "h ago"
                    }
                        
//                    else if(diff.contains("weeks") || diff.contains("week"))
//                                   {
//                                    finaltime  = (diff.prefix(1) * 7 * 24 + components.day! * 24) + components.hour!
//                                        t1 = String(finaltime) + "h ago"
//                                   }
                        
                    else{
                       if(diff.contains("days") || diff.contains("day")  )
                        {
                            finaltime = components.day! * 24 +  components.hour!
                            t1 = String(finaltime) + "h ago"
                        }
                        
                        if(diff.contains("months") || diff.contains("month") )
                                            {
                                                 finaltime = components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                t1 = String(finaltime) + "h ago"
                                            }
                         if(diff.contains("year"))
                                            {
                                                finaltime  = components.year! * 12 * 30 * 24 + components.month! * 30 * 24 + components.day! * 24 + components.hour!
                                                t1 = String(finaltime) + "h ago"
                                            }
                        
                    }
                

                    
                    
                    
                    
                    let sectionname="| " + json[i]["sectionName"].stringValue
                    let articleid=json[i]["id"].stringValue
                    let pivot = json[i]["fields"]
                    let image = pivot["thumbnail"].stringValue
                    let url = json[i]["webUrl"].stringValue
                    //debugPrint(image)
                    let article2 = article(image:image,title:title1,time:t1,section:sectionname,articleid:articleid,url:url)
                    self.article1.append(article2)
                    //self.article1[i].image.append(pivot["thumbnail"].stringValue)
                    aid.append(json[i]["id"].stringValue)
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
        autosuggest.delegate=self
        autosuggest.dataSource=self
        
        
    }
    
    
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations.last!)
        //print(type(of: locations))
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let lastCoord = locations.last
               if (lastCoord != nil) {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(lastCoord!,
                        completionHandler: { (placemarks, error) in
                            if error == nil {
                                let firstLocation = placemarks?[0]
                                //debugPrint(firstLocation)
                                let city = firstLocation?.locality ?? "No Location"
                                let country = firstLocation?.administrativeArea ?? "No Location"
                                
                                let params = ["q": city, "units":"metric","appid":"efe4c83d170983a2ea61d565fb77547c"]
                                AF.request("https://api.openweathermap.org/data/2.5/weather?", parameters: params)
                                
                                .responseJSON{
                                response in switch response.result{
                                case .success(let value):
                                    let json = JSON(value)
                                    //debugPrint(json)
                                    //print(json["main"]["temp"].float)
                                    let temp = String(Int(round(json["main"]["temp"].doubleValue))) + "°C"
                                    //debugPrint(temp)
                                    let inter = json["weather"][0]
                                    let type = inter["main"].stringValue
                                    let image: UIImage!
                                    if(type == "Clouds")
                                    {
                                        image = UIImage(named: "cloudy_weather")
                                    }
                                    else if(type == "Clear")
                                    {
                                       image = UIImage(named: "clear_weather")
                                    }
                                    else if(type == "Snow")
                                    {
                                        image = UIImage(named: "snowy_weather")
                                    }
                                    else if(type == "Rain")
                                    {
                                         image = UIImage(named: "rainy_weather")
                                    }
                                    else if(type == "Thunderstorm")
                                    {
                                         image = UIImage(named: "thunder_weather")
                                    }
                                    else{
                                         image = UIImage(named: "sunny_weather")
                                    }
                                    
                                    let weather2 = weatherdetails(image:image,city:city,state:country,temp:temp,type:type)
                                    weather1?.append(weather2)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                case .failure(let error):
                                print(error)
                                
                                    }}}})
                
                
        }
           //print("locations = \(locValue.latitude) \(locValue.longitude)")
        //print(locValue)
        //print(type(of: locValue))
            
        
       }
    
    
  
    
    
   
}

extension ArticleList : UISearchResultsUpdating{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.tableView.isHidden=false
        self.autosuggest.isHidden=true
        searchBar.text = nil
    }
    
    
    
    func showAlert(title:String){
        print(title)
    }
    func updateSearchResults(for searchController: UISearchController) {
//        print("arrrrrr")
//        print(keywordselected)
        var text = searchController.searchBar.text!
//        print(text)
        if(!keywordselected.lowercased().contains(text.lowercased()) && text != nil && text.count != 0){
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "767f6a38b6774247aeea943d787b3a5f",
            "Accept": "application/json"]
         
        let parameters = ["q": text]
        if(text.count >= 3)
        {
        AF.request("https://api.cognitive.microsoft.com/bing/v7.0/suggestions", parameters: parameters, headers: headers)
            
            .responseJSON{
            response in switch response.result{
            case .success(let value):
                let json = JSON(value)
                //debugPrint(json)
                let data =  json["suggestionGroups"][0]["searchSuggestions"]
                var i = 0
                keys = []
                while(i<data.count)
                {
                    keys.append(data[i]["displayText"].stringValue)
                    i = i+1
                }
                //debugPrint(keys)
                self.tableView.isHidden = true
                self.autosuggest.isHidden = false
            self.autosuggest.reloadData()
                
            case .failure(let error):
                print(error)
            
                    
        }
        
        }
        
        }
        else{
            //keys = []
            self.autosuggest.isHidden = true
            self.tableView.isHidden = false




        }
    
    
        }}}







extension ArticleList: UITableViewDataSource, UITableViewDelegate{

    
   
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
                if(self.article1[indexPath.row-1].articleid == datas.1["id"].string!)
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
                                        "id" : self.article1[indexPath.row-1].articleid,
                                       "image" :self.article1[indexPath.row-1].image,
                                        "section" :self.article1[indexPath.row-1].section,
                                        "date": date[indexPath.row-1],
                                        "title": self.article1[indexPath.row-1].title,
                                        "url" : self.article1[indexPath.row-1].url
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
                                        "id" : self.article1[indexPath.row-1].articleid,
                                       "image" :self.article1[indexPath.row-1].image,
                                        "section" :self.article1[indexPath.row-1].section,
                                        "date": date[indexPath.row-1],
                                        "title": self.article1[indexPath.row-1].title,
                                        "url" : self.article1[indexPath.row-1].url
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
        
            
            
            return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
        }
        return configuration
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.autosuggest.isHidden)
       { return article1.count}
        else
        {
            return keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.autosuggest.isHidden)
        {
            if(indexPath.row != 0)
            {
            print("row: \(indexPath.row)")
            let row = indexPath.row
            indexselected = row
            performSegue(withIdentifier: "showdetail", sender: self)
            //performSegue(withIdentifier: "showdetail", sender: self)
            
            }
            
        }
        else{
            print("row: \(indexPath.row)")
            keywordselected = keys[indexPath.row]
            self.tableView.isHidden = false
            self.autosuggest.isHidden = true
                      
            performSegue(withIdentifier: "searchresults", sender: self)
          
            
        }
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdetail" {


            if(segue.destination.isKind(of: Detailed.self))

            {
                let secondVC = segue.destination as! Detailed

                //let indexPath = sender as! IndexPath
                //debugPrint(indexselected)
                secondVC.data = aid[indexselected-1]
                secondVC.titlenav = article1[indexselected-1].title
                secondVC.id = article1[indexselected-1].articleid
            }
        }
        if segue.identifier == "searchresults" {
            //debugPrint("vnfjkvbnfj")
            if(segue.destination.isKind(of: Search.self))

            {
                let secondVC = segue.destination as! Search
                 
                //let indexPath = sender as! IndexPath
                //debugPrint(keywordselected)
                secondVC.data = keywordselected
                
            }
        }
    }
    
 
    
    
    
    
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(self.autosuggest.isHidden)
        
       { if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Weather") as! Weather
            if(weather1?.count != 0)
            {cell.WeatherImage.image = weather1?[indexPath.row].image
            cell.CityLabel.text = weather1?[indexPath.row].city
            cell.Tempeature.text = weather1?[indexPath.row].temp
            cell.weathertype.text = weather1?[indexPath.row].type
            cell.State.text = weather1?[indexPath.row].state}
            
            
            
            return cell
        }
        else{
           
            
        
        //let video = article1[indexPath.row-1]
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsArticles") as! NewsArticles
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.borderWidth = 0.5

        cell.BookmarkButton.tag = indexPath.row-1
        var bdata = UserDefaults.standard.array(forKey: "bookmark")
        //print(bdata)
        var f = false
        for x in JSON(bdata){
            
            if(x.1["id"].stringValue == self.article1[indexPath.row-1].articleid)
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
        cell.Title.text = article1[indexPath.row-1].title
        cell.Time.text = article1[indexPath.row-1].time
            
        cell.ArticleSection.text = article1[indexPath.row-1].section
            
        
           let url = NSURL(string:article1[indexPath.row-1].image)
            
               let imagedata = NSData.init(contentsOf: url! as URL)

           if imagedata != nil {
               cell.ArticleImage.image = UIImage(data:imagedata! as Data)
           }
           else{
            cell.ArticleImage.image = UIImage(named:"default-guardian" )
        }

            return cell}}
        else{
            
            var tablecell = UITableViewCell()
            tablecell = self.autosuggest.dequeueReusableCell(withIdentifier: "AST", for: indexPath)
            tablecell.textLabel?.text = keys[indexPath.row]
            return tablecell
            
        
        }
        return UITableViewCell()
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
                    "date": date[rownumber],
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
                    "date": date[rownumber],
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




 



