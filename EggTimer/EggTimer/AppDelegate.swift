//
//  AppDelegate.swift
//  EggTimer
//
//  Created by Lahari Ganti on 3/27/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var startMenuItem: NSMenuItem!
  @IBOutlet weak var stopMenuItem: NSMenuItem!
  @IBOutlet weak var resetMenuItem: NSMenuItem!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    enableMenus(start: true, stop: false, reset: false)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func enableMenus(start: Bool, stop: Bool, reset: Bool) {
    startMenuItem.isEnabled = start
    stopMenuItem.isEnabled = stop
    resetMenuItem.isEnabled = reset
  }
}

