//
//  HeadlinesViewController.swift
//  HW9
//
//  Created by ARPIT on 4/17/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftSpinner
import Alamofire
import SwiftyJSON


var sk = [String]()
var k = [String]()
var ks:String = ""


class HeadlinesViewController: ButtonBarPagerTabStripViewController{
    @IBOutlet weak var Homenav: UINavigationItem!
    
    @IBOutlet weak var other: UIView!
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
     
    @IBOutlet weak var autosuggest: UITableView!
    override func viewDidLoad() {
       autosuggest.isHidden = true
        
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self as! UISearchResultsUpdating
               searchController.obscuresBackgroundDuringPresentation = false
               searchController.searchBar.placeholder = "Search keyword..."
               definesPresentationContext = true
        searchController.searchBar.delegate = self as? UISearchBarDelegate
               searchController.searchBar.sizeToFit()
               Homenav.searchController = searchController
               Homenav.hidesSearchBarWhenScrolling = true
     // change selected bar color
     settings.style.buttonBarBackgroundColor = .white
     settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .systemBlue
     settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
     settings.style.selectedBarHeight = 2.0
     settings.style.buttonBarMinimumLineSpacing = 0
     settings.style.buttonBarItemTitleColor = .blue
    // settings.style.buttonBarItemsShouldFillAvailiableWidth = true
     settings.style.buttonBarLeftContentInset = 0
     settings.style.buttonBarRightContentInset = 0
     changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
     guard changeCurrentIndex == true else { return }
     oldCell?.label.textColor = .lightGray
        newCell?.label.textColor = .systemBlue
     }
     super.viewDidLoad()
        
        
        autosuggest.delegate=self as! UITableViewDelegate
        autosuggest.dataSource=self as! UITableViewDataSource
        
        
        
     }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child1")
    let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child2")
    let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child3")
    let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child4")
    let child_5 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child5")
    let child_6 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Child6")

    return [child_1, child_2,child_3,child_4,child_5,child_6]
    }

    
}

extension HeadlinesViewController:UISearchResultsUpdating{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.other.isHidden=false
        self.autosuggest.isHidden=true
        searchBar.text = nil
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        var text = searchController.searchBar.text!
         if(!ks.lowercased().contains(text.lowercased()) && text != nil && text.count != 0){
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
                    k = []
                    while(i<data.count)
                    {
                        k.append(data[i]["displayText"].stringValue)
                        i = i+1
                    }
                    //debugPrint(keys)
                    self.other.isHidden = true
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
                self.other.isHidden = false
                
            }

        }}}


extension HeadlinesViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return k.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            print("row: \(indexPath.row)")
            ks = k[indexPath.row]
        
            performSegue(withIdentifier: "hs", sender: self)
            self.autosuggest.isHidden = true
            self.other.isHidden = false
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hs" {
            
            
            if(segue.destination.isKind(of: HeadlineSearch.self))

            {
                let secondVC = segue.destination as! HeadlineSearch

                //let indexPath = sender as! IndexPath
                //debugPrint(indexselected)
                secondVC.data = ks
            }
        }
    }

        

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        

            var tablecell = UITableViewCell()
            tablecell = self.autosuggest.dequeueReusableCell(withIdentifier: "AST", for: indexPath)
            tablecell.textLabel?.text = k[indexPath.row]
            return tablecell
            
        
        
        
    }
    
    
    
}



