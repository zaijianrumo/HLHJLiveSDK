/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <UIKit/UIKit.h>

//! Project version number for Cordova.
FOUNDATION_EXPORT double CordovaVersionNumber;

//! Project version string for Cordova.
FOUNDATION_EXPORT const unsigned char CordovaVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Cordova/PublicHeader.h>

#import <TMSDK/CDV.h>
#import <TMSDK/CDVCommandDelegateImpl.h>
#import <TMSDK/CDVAvailability.h>
#import <TMSDK/CDVAvailabilityDeprecated.h>
#import <TMSDK/CDVAppDelegate.h>
#import <TMSDK/CDVPlugin.h>
#import <TMSDK/CDVPluginResult.h>
#import <TMSDK/CDVViewController.h>
#import <TMSDK/CDVCommandDelegate.h>
#import <TMSDK/CDVCommandQueue.h>
#import <TMSDK/CDVConfigParser.h>
#import <TMSDK/CDVURLProtocol.h>
#import <TMSDK/CDVInvokedUrlCommand.h>
#import <TMSDK/CDVPlugin+Resources.h>
#import <TMSDK/CDVWebViewEngineProtocol.h>
#import <TMSDK/NSDictionary+CordovaPreferences.h>
#import <TMSDK/NSMutableArray+QueueAdditions.h>
#import <TMSDK/CDVUIWebViewDelegate.h>
#import <TMSDK/CDVWhitelist.h>
#import <TMSDK/CDVScreenOrientationDelegate.h>
#import <TMSDK/CDVTimer.h>
#import <TMSDK/CDVUserAgentUtil.h>

#import <TMSDK/TMCommonDefine.h>
#import <TMSDK/TMViewController.h>
#import <TMSDK/TMController.h>

