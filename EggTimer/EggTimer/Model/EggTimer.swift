//
//  EggTimer.swift
//  EggTimer
//
//  Created by Lahari Ganti on 3/27/21.
//

import Foundation

class EggTimer {
  var delegate: EggTimerProtocol?
  
  var timer: Timer? = nil
  var startTime: Date?
  var duration: TimeInterval = 360
  var elapsedTime: TimeInterval = 0
  
  var isStopped: Bool {
    return timer == nil && elapsedTime == 0
  }
  
  var isPaused: Bool {
    return timer == nil && elapsedTime > 0
  }
  
  @objc func timerAction() {
    guard let startTime = startTime else { return }
    elapsedTime = -startTime.timeIntervalSinceNow
    let secondsRemaining = (duration - elapsedTime).rounded()
    if secondsRemaining <= 0 {
      resetTimer()
      delegate?.timerHasFinished(self)
    } else {
      delegate?.timeRemainingOntimer(self, timeRemaing: secondsRemaining)
    }
  }
  
  func startTimer() {
    startTime = Date()
    elapsedTime = 0
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(timerAction),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  func resumeTimer() {
    startTime = Date(timeIntervalSinceNow: -elapsedTime)
    
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(timerAction),
                                 userInfo: nil,
                                 repeats: true)
    timerAction()
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
    timerAction()
  }
  
  func resetTimer() {
    timer?.invalidate()
    timer = nil
    startTime = nil
    duration = 360
    elapsedTime = 0
    timerAction()
  }
}

protocol EggTimerProtocol {
  func timeRemainingOntimer(_ timer: EggTimer, timeRemaing: TimeInterval)
  func timerHasFinished(_ timer: EggTimer)
}
