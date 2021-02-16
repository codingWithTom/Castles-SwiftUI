//
//  PerkNotificationService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-15.
//

import Foundation
import Combine
import UserNotifications

typealias PerkIdentifier = String

private struct PerkNotifications {
  static let actionCategoryIdentifier = "com.codingWithTom.castles.perkActions"
  static let usePerkIdentifier = "com.codingWithTom.castles.perkActions.usePerk"
}

protocol PerkNotificationService {
  var perkActionPublisher: AnyPublisher<PerkIdentifier, Never> { get }
  func scheduleNotification(for: Perk)
}

final class PerkNotificationServiceAdapter: NSObject, PerkNotificationService {
  static let shared = PerkNotificationServiceAdapter()
  
  private var passthrough = PassthroughSubject<PerkIdentifier, Never>()
  var perkActionPublisher: AnyPublisher<PerkIdentifier, Never> {
    passthrough.eraseToAnyPublisher()
  }
  
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
    registerCategories()
  }
  
  func scheduleNotification(for perk: Perk) {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      if settings.authorizationStatus == .denied {
        return
      } else if settings.authorizationStatus == .notDetermined {
        self?.requestNotificationPermissions(for: perk)
      } else {
        self?.scheduleLocalNotification(for: perk)
      }
    }
  }
}

extension PerkNotificationServiceAdapter: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
    guard response.actionIdentifier == PerkNotifications.usePerkIdentifier else { return }
    passthrough.send(response.notification.request.identifier)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner])
  }
}

private extension PerkNotificationServiceAdapter {
  func requestNotificationPermissions(for perk: Perk) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { [weak self] success, error in
      guard success, error == nil else { return }
      self?.scheduleLocalNotification(for: perk)
    }
  }
  
  func scheduleLocalNotification(for perk: Perk) {
    let content = UNMutableNotificationContent()
    content.title = "The \(perk.name) is ready"
    content.body = "Your perk is ready to be used"
    content.categoryIdentifier = PerkNotifications.actionCategoryIdentifier
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: perk.cooldownTime, repeats: false)
    let request = UNNotificationRequest(identifier: perk.id.uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  func registerCategories() {
    let action = UNNotificationAction(identifier: PerkNotifications.usePerkIdentifier, title: "Use Perk", options: .foreground)
    let category = UNNotificationCategory(identifier: PerkNotifications.actionCategoryIdentifier,
                                          actions: [action], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }
}
