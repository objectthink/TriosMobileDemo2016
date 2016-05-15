//
//  TriosComms.swift
//  TriosMobileDemo2016
//
//  Created by stephen eshelman on 5/7/16.
//  Copyright © 2016 objectthink.com. All rights reserved.
//

import Foundation

class TriosComms : GCDAsyncSocketDelegate
{
   var _ipAddress:String!
   var _client:TCPClient!
   var _isConnected:Bool = false
   var _errorMessage:String!
   var _success:Bool = false
   var _quit:Bool = false
   var _instrument:JSON!
   var _experiment:JSON!
   var _delegate:TriosDelegate!
   
   var _socket:GCDAsyncSocket!
   
   var _tag:Int = 0
   
   let _start:String = "{$@"
   let _end:String = "!*}"
   

   
   var delegate:TriosDelegate
   {
      set
      {
         _delegate = newValue
      }
      get
      {
         return _delegate
      }
   }
   
   var ipAddress:String
   {
      set
      {
         _ipAddress = newValue
      }
      get
      {
         return _ipAddress
      }
   }
   
   var instrument:JSON
   {
      set
      {
         _instrument = newValue
      }
      get
      {
         return _instrument
      }
   }
   
   @objc func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16)
   {
      print("didConnectToHost")
   }
   
   @objc func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!)
   {
      print("socketDidDisconnect")
   }
   
   @objc func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int)
   {
      print("didReadData")
      
      guard let s = NSString(data: data, encoding: NSASCIIStringEncoding) else
      {
         print("there was a problem with encoding")
         return
      }
      
      print(s)
      
      //remove start and end
      let nostart = s.stringByReplacingOccurrencesOfString(_start, withString: "")
      let noend = nostart.stringByReplacingOccurrencesOfString(_end, withString: "")
      
      guard let json = JSON(string: noend as String) else
      {
         print ("there was a problem parsing json")
         return
      }
      
      if let instrument = json["Instrument"]
      {
         self._instrument = instrument
         
         if self._delegate != nil
         {
            self._delegate.instrumentInformation(instrument)
         }
      }

      if let signals = json["Signals"]
      {
         if self._delegate != nil
         {
            self._delegate.signals(signals)
         }
      }
      
      if let experiment = json["Experiment"]
      {
         self._experiment = experiment
      }

      _tag += 1
      
      //determine what packet it is and send to delegate
      
      _socket.readDataToData(NSData(bytes: _end, length: 3), withTimeout: 1, maxLength: 10000, tag: _tag)
   }
   
   @objc func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int)
   {
      print("didWriteDataWithTag")
   }
   
   @objc func socketDidCloseReadStream(sock: GCDAsyncSocket!)
   {
      print("socketDidCloseReadStream")
   }
   
   @objc func socket(
      sock: GCDAsyncSocket!,
      shouldTimeoutReadWithTag tag: Int,
      elapsed: NSTimeInterval,
      bytesDone length: UInt) -> NSTimeInterval
   {
      print("shouldTimeoutReadWithTag")
      return 1
   }
   
   init(ipAddress:String, use:Bool)
   {
      self.ipAddress = ipAddress

      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      
      _socket = GCDAsyncSocket(delegate: self, delegateQueue: queue!)
      
      do
      {
         if self._quit
         {
            return
         }
      
         try _socket.connectToHost(ipAddress, onPort: 50007)
         
         self._isConnected = true
         
         let data = "MobileUpdates".dataUsingEncoding(NSUTF8StringEncoding)
         
         _socket.writeData(data, withTimeout: -1, tag: 7)
         _socket.readDataToData(NSData(bytes: _end, length: 3), withTimeout: 1, maxLength: 10000, tag: _tag)
         
      }
      catch
      {
         print("connect failed")
      }
   }
   
   init(ipAddress:String)
   {
      self.ipAddress = ipAddress
      
      self._client = TCPClient(addr: ipAddress, port: 50007)
      
      let (success, errmsg) = self._client.connect(timeout: 10)
      
      _success = success
      
      _errorMessage = errmsg
      
      print(_errorMessage)
      
      if(_success)
      {
         _isConnected = true
         
         let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
         dispatch_async(queue)
         {
            let (success, errmsg) = self._client.send(str:"MobileUpdates" )
            
            self._errorMessage = errmsg
            
            print(self._errorMessage)
            
            //var first:Bool = true
            if success
            {
               while true
               {
                  if self._quit
                  {
                     break
                  }
                  
                  let data = self._client.read(1024 * 10)
                  if let d = data
                  {
                     if let str = String(bytes: d, encoding: NSUTF8StringEncoding)
                     {
                        print(str)
                        
                        guard let json = JSON(string: str) else
                        {
                           continue
                        }
                        
                        if let instrument = json["Instrument"]
                        {
                           self._instrument = instrument
                           
                           if self._delegate != nil
                           {
                              self._delegate.instrumentInformation(instrument)                              
                           }
                        }
                        
//                        if first
//                        {
//                           first = false
//                           continue
//                        }
                        
                        guard let signals = json["Signals"] else
                        {
                           continue
                        }
                        
                        if self._delegate != nil
                        {
                           self._delegate.signals(signals)
                        }
                        
//                        if json == nil
//                        {
//                           continue
//                        }
                        
//                        if let instrument = json!["Instrument"]
//                        {
//                           self._instrument = instrument
//                           
//                           print(instrument["InstrumentTypeName"])
//                        }
//
//                        if first
//                        {
//                           first = false
//                           continue
//                        }
//                        
//                        if let signals = json!["Signals"]
//                        {
//                           if self._delegate != nil
//                           {
//                              self._delegate.signals(signals)
//                           }
//                           
//                        }
                     }
                  }
                  
               }
               
            }
         }
      }
   }
   
   func close()
   {
      _socket.disconnect()
      _quit = false
      
      //_client.close()
   }
}