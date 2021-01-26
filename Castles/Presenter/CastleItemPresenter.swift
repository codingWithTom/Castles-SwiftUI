//
//  CastleItemPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-23.
//

import Foundation

final class CastleItemPresenter {
  func viewModel(for castleItem: CastleItem, shopItem: ShopItem) -> ShopItemViewModel {
    return castleItem.accept(visitor: self, data: shopItem)
  }
}

extension CastleItemPresenter: CastleItemVisitor {
  func visit(attackItem: AttackItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, quantity: "\(shopItem.quantity)",
                             price: CurrencyPresenter.goldString(shopItem.price), imageName: "sword", isIcon: false)
  }
  
  func visit(defenseItem: DefenseItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, quantity: "\(shopItem.quantity)",
                             price: CurrencyPresenter.goldString(shopItem.price), imageName: "shield", isIcon: false)
  }
  
  func visit(hpItem: HPItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, quantity: "\(shopItem.quantity)",
                             price: CurrencyPresenter.goldString(shopItem.price), imageName: "suit.heart.fill", isIcon: true)
  }
}
