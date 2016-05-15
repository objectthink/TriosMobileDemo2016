import UIKit

class MyMenuTableViewController: UITableViewController
{
   var selectedMenuItem : Int = 0
   var ipAddresses:Array<String> = Array<String>()
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      ipAddresses.append("Add")
      
      // Customize apperance of table view
      tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
      tableView.separatorStyle = .None
      tableView.backgroundColor = UIColor.clearColor()
      tableView.scrollsToTop = false
      
      // Preserve selection between presentations
      self.clearsSelectionOnViewWillAppear = false
      
      tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      // Return the number of sections.
      return 1
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      // Return the number of rows in the section.
      return ipAddresses.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
      
      if (cell == nil)
      {
         cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
         cell!.backgroundColor = UIColor.clearColor()
         cell!.textLabel?.textColor = UIColor.darkGrayColor()
         let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
         selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
         cell!.selectedBackgroundView = selectedBackgroundView
      }
      
      cell!.textLabel?.text = ipAddresses[indexPath.row]
      
      return cell!
   }
   
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
      return 40.0
   }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      print("did select row: \(indexPath.row)")
      
      if(indexPath.row == 0) //user is adding ip
      {
         //prompt user for ip, add to list, reload data
         //1. Create the alert controller.
         let alert = UIAlertController(
            title: "TA Instruments",
            message: "Enter IP address.",
            preferredStyle: .Alert)
         
         //2. Add the text field. You can configure it however you need.
         alert.addTextFieldWithConfigurationHandler(
         { (textField) -> Void in
               textField.text = ""
         })
         
         //3. Grab the value from the text field, and print it when the user clicks OK.
         alert.addAction(
            UIAlertAction(
               title: "Ok",
               style: .Default,
               handler:
               { (action) -> Void in
                  let textField = alert.textFields![0] as UITextField
                  
                  self.ipAddresses.append(textField.text!)
                  
                  tableView.reloadData()
                  
               }))
         
         alert.addAction(
            UIAlertAction(
               title: "Cancel",
               style: .Default,
               handler:
               { (action) -> Void in
               }))
         
         // 4. Present the alert.
         self.presentViewController(alert, animated: true, completion: nil)
         
         return
      }
      
      if (indexPath.row == selectedMenuItem)
      {
         return
      }
      
      selectedMenuItem = indexPath.row
      
      //Present new view controller
      let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
      var destViewController : TabBarController

      //let ai : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
      
      //ai.center = self.view.center
      //ai.hidesWhenStopped = true
      //ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
      
      //view.addSubview(ai)
      
      //ai.startAnimating()
      
      //create comms object on ip which is cell text or in list of ip's
      let trios = TriosComms(ipAddress: ipAddresses[indexPath.row], use: true)
      
      //ai.stopAnimating()

      if trios._isConnected
      {
         destViewController =
            mainStoryboard.instantiateViewControllerWithIdentifier("TestTabBarController") as! TabBarController
         
         destViewController.trios = trios
         
         sideMenuController()?.setContentViewController(destViewController)
      }
      else
      {
         let alert = UIAlertController(
            title: "Communications Error",
            message: trios._errorMessage,
            preferredStyle: .Alert)
         
         alert.addAction(
            UIAlertAction(
               title: "Ok",
               style: .Default,
               handler:
               { (action) -> Void in
                  self.toggleSideMenuView()
               }))

         presentViewController(alert, animated: true, completion: nil)
         
         selectedMenuItem = -1
         
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
   }
   
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
   
}
