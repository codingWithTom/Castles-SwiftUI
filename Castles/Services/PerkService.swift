//
//  PerkService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import Foundation
import Combine

protocol PerkService {
  var perkPublisher: AnyPublisher<[Perk], Never> { get }
  func getPerks() -> [Perk]
  func use(perk: Perk)
}

final class PerkServiceAdapter: PerkService {
  static let shared = PerkServiceAdapter()
  
  private var perks: [Perk] = [] {
    didSet {
      saveData()
      currentValuePerks.value = perks
    }
  }
  private var currentValuePerks = CurrentValueSubject<[Perk], Never>([])
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
  
  var perkPublisher: AnyPublisher<[Perk], Never> {
    currentValuePerks.eraseToAnyPublisher()
  }
  
  private init() {
    retrieveData()
  }
  
  func getPerks() -> [Perk] {
    return perks
  }
  
  func use(perk: Perk) {
    guard let perkIndex = perks.firstIndex(where: { $0.id == perk.id }) else { return }
    var usedPerk = perks[perkIndex]
    usedPerk.lastUsedDate = Date()
    perks[perkIndex] = usedPerk
  }
}

private extension PerkServiceAdapter {
  func retrieveData() {
    if let data = try? Data(contentsOf: sharedFileURL), let perks = try? JSONDecoder().decode([Perk].self, from: data) {
      self.perks = perks
    } else {
      self.perks = [
        Perk(name: "Harvest", value: 300, imageName: "plant", type: .gold, cooldownTime: 30, lastUsedDate: Date()),
        Perk(name: "Smith", value: 20, imageName: "anvil", type: .attack, cooldownTime: 60, lastUsedDate: Date())
      ]
    }
  }
  
  func saveData() {
    do {
      let data = try JSONEncoder().encode(perks)
      try data.write(to: sharedFileURL)
    } catch {
      print("Error saving perks")
    }
  }
}
