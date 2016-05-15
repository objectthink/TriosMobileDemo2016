//
//  SignalsTableViewController.swift
//  TriosMobileDemo2016
//
//  Created by stephen eshelman on 5/7/16.
//  Copyright © 2016 objectthink.com. All rights reserved.
//

import UIKit

class SignalsTableViewController: UITableViewController, TriosDelegate
{
   var _temperature:String!
   var _stress:String!
   var _shear:String!
   var _strain:String!
   var _gap:String!
   var _signals:JSON!

   var _keys:Array<String>!
   var _values:Array<String>!
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
   }
   
   func experiment(experiment:JSON)
   {
   }

   func instrumentInformation(instrumentInformation:JSON)
   {
   }
   
   func signals(signals:JSON)
   {
      print("signals:statusviewcontroller")
      
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
         
         self._keys = Array<String>()
         self._values = Array<String>()
         
         for key in (signals.object?.keys)!
         {
            self._keys.append(key)
            
            self._values.append(
               (signals[key]?["Value"]!.string)! + " " + (signals[key]?["Units"]!.string)!)
         }
         
         self._signals = signals
         
         self.tableView.reloadData()
      })
   }
   
   override func viewWillAppear(animated: Bool)
   {
      (tabBarController as! TabBarController).trios._delegate = self
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      // #warning Incomplete implementation, return the number of rows
      
      guard _signals != nil else
      {
         return 0
      }
      
      return (_signals.object?.keys.count)!
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("SignalCell", forIndexPath: indexPath)
      
      cell.textLabel?.text = _keys[indexPath.row]
      cell.detailTextLabel?.text = _values[indexPath.row]
      
      return cell
   }
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
