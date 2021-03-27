//
//  PrefsVC.swift
//  EggTimer
//
//  Created by Lahari Ganti on 3/27/21.
//

import Cocoa

class PrefsVC: NSViewController {
  @IBOutlet weak var presetsPopup: NSPopUpButton!
  @IBOutlet weak var customTextField: NSTextField!
  @IBOutlet weak var customSlider: NSSlider!
  var prefs = Preferences()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showExistingPrefs()
  }
  
  func showExistingPrefs() {
    let selectedTimeInMinutes = Int(prefs.selectedtime) / 60
    presetsPopup.selectItem(withTitle: "Custom")
    customSlider.isEnabled = true
    
    for item in presetsPopup.itemArray {
      if item.tag == selectedTimeInMinutes {
        presetsPopup.selectedItem = item
        customSlider.isEnabled = false
        break
      }
    }
    
    customSlider.integerValue = selectedTimeInMinutes
    showSliderValueAsText()
  }
  
  func showSliderValueAsText() {
    let newTimerDuration = customSlider.integerValue
    let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
    customTextField.stringValue = "\(newTimerDuration) \(minutesDescription)"
  }
  
  func saveNewPrefs() {
    prefs.selectedtime = customSlider.doubleValue * 60
    NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"), object: nil)
  }
  
  @IBAction func popupValueChanged(_ sender: NSPopUpButton) {
    if sender.selectedItem?.title == "Custom" {
      customSlider.isEnabled = true
      return
    }
    
    let newTimeDuration = sender.selectedTag()
    customSlider.integerValue = newTimeDuration
    showSliderValueAsText()
    customSlider.isEnabled = false
  }
  
  
  @IBAction func sliderValueChanged(_ sender: Any) {
    showSliderValueAsText()
  }
  
  @IBAction func cancelButtonClicked(_ sender: Any) {
    view.window?.close()
  }
  
  
  @IBAction func okButtonClicked(_ sender: Any) {
    saveNewPrefs()
    view.window?.close()
  }
}
