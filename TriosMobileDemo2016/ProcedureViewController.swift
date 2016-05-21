//
//  ProcedureViewController.swift
//  TriosMobileDemo2016
//
//  Created by stephen eshelman on 5/15/16.
//  Copyright © 2016 objectthink.com. All rights reserved.
//

import UIKit

class ProcedureViewController: UIViewController, TriosDelegate, UITableViewDelegate, UITableViewDataSource
{
   @IBOutlet var _segmentedControl: UISegmentedControl!
   @IBOutlet var _tableView: UITableView!
   
   var _trios:TriosComms!
   
   var _keys:Array<String>!
   var _values:Array<String>!
   var _steps:Array<Dictionary<String, String>> = []
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      _keys = Array<String>()
      _values = Array<String>()
      _trios = (tabBarController as! TabBarController).trios

      _segmentedControl.selectedSegmentIndex = 0
      tabChoice(_segmentedControl)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      //get the tab bar controller that is managing this view which is of type TabBarController
      //(could rename to TriosTabBarController)
      
      //set this view as the trios comms delegate
      (tabBarController as! TabBarController).trios._delegate = self

      if _trios._experiment != nil
      {
         //print(_trios._experiment)
      }
   }
   
   func instrumentInformation(instrumentInformation:JSON)
   {
   }
   
   func experiment(experiment:JSON)
   {
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
         self.tabChoice(self._segmentedControl)
      })
   }
   
   func signals(signalsJSON:JSON)
   {
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func tabChoice(sender: AnyObject)
   {
      _keys.removeAll()
      _values.removeAll()
      _steps.removeAll()
      
      let sections:[String] = ["Sample", "Geometry", "Procedure"]
      
      print(sections)
      
      if _trios._experiment == nil
      {
         return
      }
      
      //update list
      if let procedureSection = _trios._experiment[sections[_segmentedControl.selectedSegmentIndex]]
      {
         for key in (procedureSection.object?.keys)!
         {
            if key == "Steps"
            {
               _steps.removeAll()
               
               let stepObject = procedureSection["Steps"]?.object!
               
               for stepKey in (stepObject!.keys)
               {
                  var stepDictionary = Dictionary<String, String>()
                  for skey in (stepObject![stepKey]?.object?.keys)!
                  {
                     stepDictionary[skey] = stepObject![stepKey]!.object![skey]!.string
                  }
                  _steps.append(stepDictionary)
               }               
            }
            else
            {
               _keys.append(key)
               
               self._values.append((procedureSection[key]?.string)!)
            }
            
         }
         
      }

      _tableView.reloadData()
   }
   
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
   {
      if section == 0
      {
         return _segmentedControl.titleForSegmentAtIndex(_segmentedControl.selectedSegmentIndex)
      }
      else
      {
         return "Step \(section)"
         
      }
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      if _segmentedControl.selectedSegmentIndex == 2
      {
         return 1 + _steps.count
      }
      else
      {
         return 1
      }
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      if _segmentedControl.selectedSegmentIndex == 2
      {
         if section == 0
         {
            return _keys.count
         }
         else
         {
            return _steps[section - 1].keys.count
         }
      }
      else
      {
         return _keys.count
      }
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("ExperimentCell", forIndexPath: indexPath)
      
      if indexPath.section == 0
      {
         cell.textLabel?.text = _keys[indexPath.row]
         cell.detailTextLabel?.text = _values[indexPath.row]
      }
      else
      {
         //procedure steps
         cell.textLabel?.text = stepKeyForIndex(indexPath.row, section: indexPath.section)
         cell.detailTextLabel?.text = stepValueForIndex(indexPath.row, section: indexPath.section)
      }
      
      //demo accesory view
      //will be used to transition to a view controller that shows the full row
      if _keys[indexPath.row] == "Notes"
      {
         cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
      }
      else
      {
         cell.accessoryType = UITableViewCellAccessoryType.None
      }
      
      return cell
   }
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
   func stepKeyForIndex(index:Int, section:Int)->String
   {
      var currentIndex:Int = 0
      for key in _steps[section - 1].keys
      {
         if currentIndex == index
         {
            return key
         }
         
         currentIndex = currentIndex + 1
      }
      
      return ""
   }
   
   func stepValueForIndex(index:Int, section:Int)->String
   {
      var currentIndex:Int = 0
      for key in _steps[section - 1].keys
      {
         if currentIndex == index
         {
            return _steps[section - 1][key]!
         }
         
         currentIndex = currentIndex + 1
      }
      
      return ""
   }
}
