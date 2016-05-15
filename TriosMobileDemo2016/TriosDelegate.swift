//
//  TriosDelegate.swift
//  TriosMobileDemo2016
//
//  Created by stephen eshelman on 5/7/16.
//  Copyright © 2016 objectthink.com. All rights reserved.
//

import Foundation

protocol TriosDelegate
{
   func instrumentInformation(instrumentInformation:JSON)
   func signals(signals:JSON)
   func experiment(experiment:JSON)
}