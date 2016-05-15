//
//  TabBarController.swift
//  SwiftSideMenu
//
//  Created by stephen eshelman on 5/4/16.
//  Copyright © 2016 Evgeny Nazarov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController
{
   var _trios:TriosComms!
   
   var trios:TriosComms
   {
      set
      {
         _trios = newValue
      }
      get
      {
         return _trios
      }
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      let image = UIImage(named: "text-align-justify-7")
      
      navigationItem.leftBarButtonItem = UIBarButtonItem(
         image: image,
         style: .Plain,
         target: self,
         action: #selector(burgerTapped))
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(
         title: "Idle",
         style: .Plain,
         target: self,
         action: nil)
   }
   
   func burgerTapped()
   {
      toggleSideMenuView()
   }
   
   // Do any additional setup after loading the view
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func viewWillAppear(animated: Bool)
   {
      self.navigationItem.title = trios.ipAddress
   }
   
   override func viewWillDisappear(animated: Bool)
   {
      print("tab bar controller is leaving the room")
      
      _trios.close()
   }

   override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
   {
      
      
   }
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
   }
}
