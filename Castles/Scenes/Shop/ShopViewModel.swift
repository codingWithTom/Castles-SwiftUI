//
//  ShopViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-23.
//

import Foundation
import Combine

struct ShopItemViewModel {
  let itemID: String
  let name: String
  let quantity: String
  let price: String
  let imageName: String
  let isIcon: Bool
}

final class ShopViewModel: ObservableObject {
  struct Dependencies {
    var getShopPublisher: GetShopItemPublisher = GetShopItemPublisherAdapter()
    var useCastleItem: UseCastleItem = UseCastleItemAdapter()
    var purchaseShopItem: PurchaseShopItem = PurchaseShopItemAdapter()
    var getCastles: GetCastles = GetCastlesAdapter()
  }
  private let dependencies: Dependencies
  private var shopSubscriber: AnyCancellable?
  
  var castleNames: [String] {
    return dependencies.getCastles.execute().map { $0.name }
  }
  @Published var items: [ShopItemViewModel] = []
  private var shopItems: [ShopItem] = [] {
    didSet {
      let shopItemPresenter = ShopItemPresenter()
      self.items = shopItems.map { item in shopItemPresenter.viewModel(for: item) }
    }
  }
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func isItemForCastle(itemID: String) -> Bool {
    guard let item = shopItems.first(where: { $0.itemID == itemID }) else { return false }
    return item.wrappedItem is CastleItem
  }
  
  func selectedCastle(castleIndex: Int, for itemID: String) {
    guard
      let item = shopItems.first(where: { $0.itemID == itemID }),
      let castleItem = item.wrappedItem as? CastleItem
    else { return }
    let castle = dependencies.getCastles.execute()[castleIndex]
    dependencies.purchaseShopItem.execute(item: item)
    dependencies.useCastleItem.execute(item: castleItem, castle: castle)
  }
}

private extension ShopViewModel {
  func observe() {
    shopSubscriber = dependencies.getShopPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.shopItems = $0
    }
  }
}
