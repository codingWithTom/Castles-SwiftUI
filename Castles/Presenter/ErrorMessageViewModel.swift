//
//  ErrorMessageViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-28.
//

import Foundation

struct ErrorMessageViewModel {
  let title: String
  let message: String
}

final class ErrorPresenter {
  static func viewModel(for error: CastlesError) -> ErrorMessageViewModel {
    switch error {
    case .insufficientGold:
      return ErrorMessageViewModel(title: "Insufficient Gold", message: "We are sorry, you don't have enough gold to buy this. Loot more before coming back!")
    case .unknown:
      return ErrorMessageViewModel(title: "Unknown Error", message: "Unfortunately we don't know what happen. Please try again.")
    }
  }
}
