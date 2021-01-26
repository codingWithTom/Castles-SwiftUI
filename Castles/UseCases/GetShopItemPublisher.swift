//
//  GetShopItemPublisher.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import Foundation
import Combine

protocol GetShopItemPublisher {
  func execute() -> AnyPublisher<[ShopItem], Never>
}

final class GetShopItemPublisherAdapter: GetShopItemPublisher {
  struct Dependencies {
    var shopService: ShopService = ShopServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<[ShopItem], Never> {
    return dependencies.shopService.shopPublisher
  }
}
