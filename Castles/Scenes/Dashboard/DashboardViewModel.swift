//
//  DashboardViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import UIKit
import Combine
import SwiftUI

struct CastleViewModel: Identifiable {
  enum Condition {
    case onFire
    case normal
    case perfect
  }
  let id: String
  let name: String
  let imageName: String
  let attack: String
  let defense: String
  let hp: String
  let condition: Condition
}

struct TurnViewModel {
  let isPlayerTurn: Bool
  let color: UIColor
}

enum DashboardItem: Identifiable {
  case castle(CastleViewModel)
  case action(ActionViewModel)
  
  var id: String {
    switch self {
    case .castle(let viewModel):
      return viewModel.id
    case .action(let viewModel):
      return viewModel.id
    }
  }
}

struct ActionViewModel: Identifiable {
  let id: String
  let value: String
  let name: String
  let imageName: String
  let isIcon: Bool
  let effectImageName: String
  let startDate: Date?
  let endDate: Date?
  let startActivity: () -> Void
}


final class DashboardViewModel: ObservableObject {
  struct Dependencies {
    var getCastlePublisher: GetCastlesPublisher = GetCastlesPublisherAdapter()
    var getGoldPublisher: GetGoldPublisher = GetGoldPublisherAdapter()
    var getOutcomePublisher: GetOutcomePublisher = GetOutcomePublisherAdapter()
    var getTurnPublisher: GetTurnPublisher = GetTurnPublisherAdapter()
    var createCastle: CreateCastle = CreateCastleAdapter()
    var performPlayerTurn: PerformPlayerTurn = PerformPlayerTurnAdapter()
    var performBarbarianTurn: PerformBarbarianTurn = PerformBarbarianTurnAdapter()
    var getPerkPublisher: GetPerksPublisher = GetPerksPublisherAdapter()
    var usePerk: UsePerk = UsePerkAdapter()
  }
  private let dependencies: Dependencies
  @Published var goldAmount: String = "0"
  @Published var items: [DashboardItem] = []
  @Published var actionItems: [DashboardItem] = []
  @Published var outcome: Outcome?
  @Published var turns: [TurnViewModel] = []
  @Published var dashboardSheet: DashboardSheet = .outcome
  @Published var errorMessage: ErrorMessageViewModel?
  private var subscriptions = Set<AnyCancellable>()
  private var perks: [Perk] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func userSelectedCastleForAttack(castleID: String) {
    dependencies.performPlayerTurn.executeAttack(castleID: castleID)
  }
  
  func userSelectedCastleForFortification(castleID: String) {
    dependencies.performPlayerTurn.executeFortify(castleID: castleID)
  }
  
  func userSelectedNextTurn() {
    dependencies.performBarbarianTurn.execute()
  }
  
  func tappedShop() {
    dashboardSheet = .shop
  }
  
  func tappedAction(withID id: String) {
    guard let index = actionItems.firstIndex(where: { $0.id == id }) else { return }
    if index == 0 {
      userDidTapAddCastle()
    } else {
      userDidUsePerk(at: index - 1)
    }
  }
}

private extension DashboardViewModel {
  func observe() {
    dependencies.getGoldPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.goldAmount = CurrencyPresenter.goldString($0)
    }.store(in: &subscriptions)
    dependencies.getCastlePublisher.execute().receive(on: RunLoop.main).sink { [weak self] castles in
      guard let self = self else { return }
      withAnimation {
        self.items = castles.map { DashboardItem.castle(CastlePresenter.castleViewModel(from: $0)) }
      }
    }.store(in: &subscriptions)
    dependencies.getTurnPublisher.execute().receive(on: RunLoop.main).sink { [weak self] turns in
      self?.turns = turns.map { TurnPresenter.turnViewModel(from: $0) }
    }.store(in: &subscriptions)
    dependencies.getOutcomePublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.dashboardSheet = .outcome
      self?.outcome = $0
    }.store(in: &subscriptions)
    dependencies.getPerkPublisher.execute().receive(on: RunLoop.main).sink { [weak self] perks in
      self?.perks = perks
      self?.actionItems =
        [DashboardItem.action(ActionViewModel(id: "addCastleAction", value: "- 1,000", name: "Add Castle", imageName: "plus.circle",
                                             isIcon: true, effectImageName: "gold", startDate: nil, endDate: nil, startActivity: { }))]
        + perks.map { DashboardItem.action(PerkPresenter.viewModel(for: $0)) }
    }.store(in: &subscriptions)
  }
  
  func userDidTapAddCastle() {
    if case let .failure(error) = dependencies.createCastle.execute() {
      errorMessage = ErrorPresenter.viewModel(for: error)
    }
  }
  
  func userDidUsePerk(at index: Int) {
    let perk = perks[index]
    guard perk.isCooldownPassed else { return }
    dependencies.usePerk.execute(perk: perk)
  }
}
