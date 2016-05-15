//
//  MainViewController.swift
//  SwiftSideMenu
//
//  Created by stephen eshelman on 5/7/16.
//  Copyright © 2016 objectthink.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ENSideMenuDelegate
{
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func toggleSideMenu(sender: AnyObject)
   {
      toggleSideMenuView()
   }
   
   // MARK: - ENSideMenu Delegate
   func sideMenuWillOpen()
   {
      print("sideMenuWillOpen")
   }
   
   func sideMenuWillClose()
   {
      print("sideMenuWillClose")
   }
   
   func sideMenuDidClose()
   {
      print("sideMenuDidClose")
   }
   
   func sideMenuDidOpen()
   {
      print("sideMenuDidOpen")
   }
   
   func sideMenuShouldOpenSideMenu() -> Bool
   {
      print("sideMenuShouldOpenSideMenu")
      return true
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
