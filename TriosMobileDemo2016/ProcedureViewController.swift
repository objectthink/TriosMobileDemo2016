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
               continue
            }
            
            _keys.append(key)
            
            self._values.append((procedureSection[key]?.string)!)
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
         return 4
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
            return 0
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
      
      cell.textLabel?.text = _keys[indexPath.row]
      cell.detailTextLabel?.text = _values[indexPath.row]
      
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
   
}
