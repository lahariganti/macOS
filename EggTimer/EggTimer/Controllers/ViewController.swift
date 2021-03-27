//
//  ViewController.swift
//  EggTimer
//
//  Created by Lahari Ganti on 3/27/21.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
  @IBOutlet weak var timeField: NSTextField!
  @IBOutlet weak var eggImageView: NSImageView!
  @IBOutlet weak var startButton: NSButton!
  @IBOutlet weak var stopButton: NSButton!
  @IBOutlet weak var resetButton: NSButton!
  var eggTimer = EggTimer()
  var prefs = Preferences()
  var soundPlayer: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    eggTimer.delegate = self
    setupPrefs()
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  
  @IBAction func startButtonClicked(_ sender: Any) {
    if eggTimer.isPaused {
      eggTimer.resumeTimer()
    } else {
      eggTimer.duration = prefs.selectedtime
      eggTimer.startTimer()
    }
    
    prepareSound()
    configureButtonsAndMenus()
  }
  
  @IBAction func stopButtonClicked(_ sender: Any) {
    eggTimer.stopTimer()
    configureButtonsAndMenus()
  }
  
  @IBAction func resetButtonClicked(_ sender: Any) {
    eggTimer.resetTimer()
    updateDisplay(for: prefs.selectedtime)
    configureButtonsAndMenus()
  }
  
  @IBAction func startTimerMenuItemSelected(_ sender: Any) {
    startButtonClicked(sender)
  }
  
  @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
    stopButtonClicked(sender)
  }
  
  @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
    resetButtonClicked(sender)
  }
  
}

extension ViewController: EggTimerProtocol {
  func timeRemainingOntimer(_ timer: EggTimer, timeRemaing: TimeInterval) {
    updateDisplay(for: timeRemaing)
  }
  
  func timerHasFinished(_ timer: EggTimer) {
    updateDisplay(for: 0)
    playSound()
  }
  
  func updateDisplay(for timeRemaining: TimeInterval) {
    timeField.stringValue = textToDisplay(for: timeRemaining)
    eggImageView.image = imageToDisplay(for: timeRemaining)
  }
  
  private func textToDisplay(for timeRemaining: TimeInterval) -> String {
    if timeRemaining == 0 { return "Done" }
    let minutesRemaining = floor(timeRemaining / 60)
    let secondsRemaining = timeRemaining - (minutesRemaining * 60)
    let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
    let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
    return timeRemainingDisplay
  }
  
  private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
    let percentageComplete = 100 - (timeRemaining / prefs.selectedtime * 100)
    
    if eggTimer.isStopped {
      let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
      return NSImage(named: stoppedImageName)
    }
    
    let imageName: String
    switch percentageComplete {
    case 0 ..< 25:
      imageName = "0"
    case 25 ..< 50:
      imageName = "25"
    case 50 ..< 75:
      imageName = "50"
    case 75 ..< 100:
      imageName = "75"
    default:
      imageName = "100"
    }
    
    return NSImage(named: imageName)
  }
  
  func configureButtonsAndMenus() {
    let enableStart: Bool
    let enableStop: Bool
    let enableReset: Bool
    
    if eggTimer.isStopped {
      enableStart = true
      enableStop = false
      enableReset = false
    } else if eggTimer.isPaused {
      enableStart = true
      enableStop = false
      enableReset = true
    } else {
      enableStart = false
      enableStop = true
      enableReset = false
    }
    
    startButton.isEnabled = enableStart
    stopButton.isEnabled = enableStop
    resetButton.isEnabled = enableReset
    
    if let appDel = NSApplication.shared.delegate as? AppDelegate {
      appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
    }
  }
}

extension ViewController {
  func setupPrefs() {
    updateDisplay(for: prefs.selectedtime)
    
    let notificationName = Notification.Name(rawValue: "PrefsChanged")
    NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
      self.updateFromprefs()
    }
  }
  
  func updateFromprefs() {
    self.eggTimer.duration = self.prefs.selectedtime
    self.resetButtonClicked(self)
  }
}

extension ViewController {
  func prepareSound() {
    guard let audioFileURL = Bundle.main.url(forResource: "ding", withExtension: "mp3") else { return }
    
    do {
      soundPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
      soundPlayer?.prepareToPlay()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func playSound() {
    soundPlayer?.play()
  }
}
