//
//  PerkTimelineProvider.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import Foundation
import WidgetKit

struct PerkTimelineProvider: TimelineProvider {
  struct Dependencies {
    var getMostRecentPerk: GetPerkWithMostRecentCooldown = GetPerkWithMostRecentCooldownAdapter()
  }
  private let dependencies: Dependencies
  
  var samplePerk: Perk {
    let oneHourAgo = Date().addingTimeInterval(-3600)
    return Perk(id: UUID(), name: "Harvest", value: 100, imageName: "plant", type: .gold,
                cooldownTime: 30, lastUsedDate: oneHourAgo)
  }
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func placeholder(in context: Context) -> PerkEntry {
    return PerkEntry(date: Date(), perk: samplePerk)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (PerkEntry) -> Void) {
    let entry: PerkEntry
    if context.isPreview {
      entry = PerkEntry(date: Date(), perk: samplePerk)
    } else {
      let mostRecentPerk = dependencies.getMostRecentPerk.execute()
      entry = PerkEntry(date: Date(), perk: mostRecentPerk ?? samplePerk)
    }
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<PerkEntry>) -> Void) {
    let entries: [PerkEntry]
    if let mostRecentPerk = dependencies.getMostRecentPerk.execute() {
      entries = [
        PerkEntry(date: Date(), perk: mostRecentPerk),
        PerkEntry(date: mostRecentPerk.cooldownDate, perk: mostRecentPerk)
      ]
    } else {
      entries = [PerkEntry(date: Date(), perk: samplePerk)]
    }
    completion(Timeline(entries: entries, policy: .never))
  }
}
