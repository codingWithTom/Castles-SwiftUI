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
  let id: String
  let name: String
  let imageName: String
  let attack: String
  let defense: String
  let hp: String
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
  var id: String { imageName }
  let price: String
  let name: String
  let imageName: String
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
  }
  private let dependencies: Dependencies
  @Published var goldAmount: String = "0"
  @Published var items: [DashboardItem] = []
  @Published var outcome: Outcome?
  @Published var turns: [TurnViewModel] = []
  @Published var dashboardSheet: DashboardSheet = .outcome
  private var goldSubscriber: AnyCancellable?
  private var castlesSubscriber: AnyCancellable?
  private var turnSubscriber: AnyCancellable?
  private var outcomeSubscirber: AnyCancellable?
  private let actionItems: [DashboardItem] = [
    DashboardItem.action(ActionViewModel(price: "1,000", name: "Add Castle", imageName: "plus.circle"))
  ]
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func userDidTapAddCastle() {
    dependencies.createCastle.execute()
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
}

private extension DashboardViewModel {
  func observe() {
    goldSubscriber = dependencies.getGoldPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.goldAmount = CurrencyPresenter.goldString($0)
    }
    castlesSubscriber = dependencies.getCastlePublisher.execute().receive(on: RunLoop.main).sink { [weak self] castles in
      guard let self = self else { return }
      withAnimation {
        self.items = castles.map { DashboardItem.castle(CastlePresenter.castleViewModel(from: $0)) } + self.actionItems
      }
    }
    turnSubscriber = dependencies.getTurnPublisher.execute().receive(on: RunLoop.main).sink { [weak self] turns in
      self?.turns = turns.map { TurnPresenter.turnViewModel(from: $0) }
    }
    outcomeSubscirber = dependencies.getOutcomePublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.dashboardSheet = .outcome
      self?.outcome = $0
    }
  }
}
