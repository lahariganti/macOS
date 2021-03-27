//
//  Preferences.swift
//  EggTimer
//
//  Created by Lahari Ganti on 3/27/21.
//

import Foundation

class Preferences {
  var selectedtime: TimeInterval {
    get {
      let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
      if savedTime > 0 {
        return savedTime
      }
      
      return 30
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "selectedTime")
    }
  }
}
