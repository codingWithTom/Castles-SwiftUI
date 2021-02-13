//
//  ProgressViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import Foundation

final class ProgressViewModel {
  private let startDate: Date
  private let endDate: Date
  private var timer: Timer?
  @Published var progress: Double = 0.0
  @Published var isComplete = false
  
  init(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
    startCooldown()
  }
}

private extension ProgressViewModel {
  func startCooldown() {
    timer?.invalidate()
    guard endDate.timeIntervalSinceNow > 0 else {
      isComplete = true
      return
    }
    let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      guard self.endDate.timeIntervalSinceNow > 0 else {
        self.isComplete = true
        self.timer?.invalidate()
        return
      }
      let total = self.endDate.timeIntervalSince(self.startDate)
      let timeSinceStart = Date().timeIntervalSince(self.startDate)
      self.progress = timeSinceStart / total
    }
    self.timer = timer
    RunLoop.current.add(timer, forMode: .common)
  }
}
