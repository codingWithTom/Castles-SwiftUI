//
//  KindgdomService.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import Foundation

protocol KingdomService {
  func getCastles() -> [Castle]
}

final class KingdomServiceAdapter: KingdomService {
  static let shared = KingdomServiceAdapter()
  
  private var sharedFileURL: URL {
    guard
      let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.codingWithTom.castles.container")
    else { return fileURL }
    return URL(fileURLWithPath: "castles", relativeTo: directory)
  }
  
  private var fileURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "castles", relativeTo: directory)
  }
  
  func getCastles() -> [Castle] {
    return retrieveCastles()
  }
}

private extension KingdomServiceAdapter {
  func retrieveCastles() -> [Castle] {
    if let data = try? Data(contentsOf: sharedFileURL), let kingdom = try? JSONDecoder().decode(Kingdom.self, from: data) {
      return kingdom.castles
    } else {
      return []
    }
  }
}
