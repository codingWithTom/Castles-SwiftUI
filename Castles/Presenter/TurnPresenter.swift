//
//  TurnPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-05.
//

import UIKit

final class TurnPresenter {
  static func turnViewModel(from turn: Turn) -> TurnViewModel {
    return TurnViewModel(isPlayerTurn: turn.isPlayer, color: turn.isPlayer ? .blue : .red)
  }
}
