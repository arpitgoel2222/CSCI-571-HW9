//
//  Bookmark.swift
//  HW9
//
//  Created by ARPIT on 4/22/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import SwiftyJSON

var barticles : [article] = []
var indexselected3:Int = 0
var count2 :Int = 0
class Bookmark: UIViewController {

    @IBOutlet weak var bookmarkcollection: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        label.isHidden = false
        bookmarkcollection.isHidden = true
        barticles=[]
       
        
      
        
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmark")
        
        if(data?.count == 0 || data == nil)
        {
            label.text = "No bookmarks added"
        }
        else{
            label.isHidden = true
            bookmarkcollection.isHidden = false
            let json = JSON(data)
            var i = 0
            while(i<json.count)
            {
                let image = json[i]["image"].stringValue
                let title  = json[i]["title"].stringValue
                var date = json[i]["date"].stringValue
               //print(date)
                var section = json[i]["section"].stringValue
                if(!section.contains("|"))
                {
                    section = "| " + section
                }
                
                let id = json[i]["id"].stringValue
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = " dd MMM "
                let datee = dateFormatterGet.date(from: date)
                //print(datee)
                let url = json[i]["url"].stringValue
                date =  dateFormatterPrint.string(from: datee ?? Date())
                //print(date)
                i = i + 1
                let article2 = article(image: image, title: title, time: date, section: section, articleid: id, url: url)
                barticles.append(article2)
                
            
                
            }
            DispatchQueue.main.async {
                
                self.bookmarkcollection.reloadData()
              
                
                
            }
            bookmarkcollection.delegate=self
            bookmarkcollection.dataSource=self
            
            
            
            

        }
        

    }
    

    

}

extension Bookmark: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barticles.count
        
    }
     func collectionView(_ tableView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
               let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                   let textString = barticles[indexPath.row].url + "#CSCI_571_NewsApp"
                   let tweetUrl = barticles[indexPath.row].title
                   
                   let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
                   
                   // encode a space to %20 for example
                   let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                   
                   // cast to an url
                   let url = URL(string: escapedShareString)
                   
                   // open in safari
                   //UIApplication.shared.openURL(url!)
                   UIApplication.shared.open(url!)
               }
                let bookmark = UIAction(title: "Bookmark",image:UIImage(systemName: "bookmark.fill"),  identifier: nil)
                { action in
                        let userdefaults = UserDefaults.standard
                        var data = userdefaults.array(forKey: "bookmark")
 
                            var data2  = [
                                "id" : barticles[indexPath.row].articleid,
                                    "image" :barticles[indexPath.row].image,
                            "section" :barticles[indexPath.row].section,
                                "date": barticles[indexPath.row].time,
                            "title": barticles[indexPath.row].title
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
                                    barticles.remove(at : i)
                                           }
        
                                
                            userdefaults.set(data, forKey: "bookmark")
                            userdefaults.synchronize()
                    
                    
                    //self.viewDidLoad()
                    
                    let delay = 0.8
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay )
                    {
                        self.bookmarkcollection.performBatchUpdates({
                            //self.bookmarkcollection.deleteItems(at: [indexPath])
                            self.viewDidLoad()
                        })
                    }}
               
               return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
           }
           return configuration
       }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.frame.size.width/2.0 - 50
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bd" {
        let cell = sender as! UICollectionViewCell
        
        let indexPath = bookmarkcollection.indexPath(for: cell)!
        
        let destination = segue.destination as! BookmarkDetailed
            destination.titlenav = barticles[indexPath.item].title
            destination.id = barticles[indexPath.item].articleid
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        cell.contentView.layer.borderWidth = 0.5
        //cell.layer.borderRadius = 10
        cell.BookmarkButton.addTarget(self, action: #selector(add), for: UIControl.Event.touchUpInside)
        cell.BookmarkDate.text = barticles[indexPath.row].time
        cell.BookmarkTitle.text = barticles[indexPath.row].title
        cell.BookmarkSection.text = barticles[indexPath.row].section
        let url = NSURL(string:barticles[indexPath.row].image)
        let imagedata = NSData.init(contentsOf: url! as URL)

        if imagedata != nil {
            cell.BookmarkImage.image = UIImage(data:imagedata! as Data)
        }
        else{
         cell.BookmarkImage.image = UIImage(named:"default-guardian")
        
    }
        return cell
    }
    
    
    @objc func add(sender:UIButton){
        let rownumber = sender.tag
        //print(rownumber)
        let userdefaults = UserDefaults.standard
        var data = userdefaults.array(forKey: "bookmark")
                var data2  = [
                    "id" : barticles[rownumber].articleid,
                    "image" :barticles[rownumber].image,
                    "section" : barticles[rownumber].section,
                    "date": barticles[rownumber].time,
                    "title": barticles[rownumber].title,
                    "url" : barticles[rownumber].url
                    
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
                    barticles.remove(at: i)

                }
               
                userdefaults.set(data, forKey: "bookmark")
                userdefaults.synchronize()
                
                viewDidLoad()
    
                
                
        
    }
}
