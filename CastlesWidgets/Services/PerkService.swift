//
//  PerkService.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import Foundation

protocol PerkService {
  func getPerks() -> [Perk]
}

final class PerkServiceAdapter: PerkService {
  static let shared = PerkServiceAdapter()
  
  private var sharedFileURL: URL {
    guard
      let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.codingWithTom.castles.container")
    else { return fileURL }
    return URL(fileURLWithPath: "perks", relativeTo: directory)
  }
  
  private var fileURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "perks", relativeTo: directory)
  }
  
  func getPerks() -> [Perk] {
    return retrievePerks()
  }
}

private extension PerkServiceAdapter {
  func retrievePerks() -> [Perk] {
    if let data = try? Data(contentsOf: sharedFileURL), let perks = try? JSONDecoder().decode([Perk].self, from: data) {
      return perks
    } else {
      return []
    }
  }
}
