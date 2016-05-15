//
//  StatusViewController.swift
//  SwiftSideMenu
//
//  Created by stephen eshelman on 5/4/16.
//  Copyright © 2016 Evgeny Nazarov. All rights reserved.
//

import UIKit

class StatusViewController: UITableViewController, TriosDelegate
{
   var _keys:Array<String>!
   var _values:Array<String>!

   override func viewDidLoad()
   {
      super.viewDidLoad()
   }

   override func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 1
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      if _keys != nil
      {
         return _keys.count
      }
      else
      {
         return 0
      }
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell", forIndexPath: indexPath)
      
      cell.textLabel?.text = _keys[indexPath.row]
      cell.detailTextLabel?.text = _values[indexPath.row]
      
      return cell
   }
   
   func instrumentInformation(instrumentInformation:JSON)
   {
      print("instrumentinformation:statusviewcontroller")
      
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
      })
   }
   
   func experiment(experiment:JSON)
   {
   }

   func signals(signalsJSON:JSON)
   {
   }
   
   override func viewWillAppear(animated: Bool)
   {
      (tabBarController as! TabBarController).trios._delegate = self
      
      let trios:TriosComms = (tabBarController as! TabBarController).trios
      
      guard let instrument = trios._instrument else
      {
         return
      }

      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
         self._keys = Array<String>()
         self._values = Array<String>()
         
         for key in (instrument.object?.keys)!
         {
            self._keys.append(key)
            
            self._values.append(
               (instrument[key]?.string)!)
         }
         
         self.tableView.reloadData()

      })
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
   }
}
