//
//  CastleCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-19.
//

import SwiftUI
import SpriteKit

final class CastleScene: SKScene {
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.2)
  }
}

struct CastleCell: View {
  struct Dependencies {
    var castleEffect: CastleEffect = CastleEffectAdapter()
  }
  var dependencies: Dependencies = .init()
  let viewModel: CastleViewModel
  
  var castleScene: SKScene? {
    guard let particleNode = dependencies.castleEffect.effect(for: viewModel.condition) else {
      return nil
    }
    let scene = CastleScene(size: CGSize(width: 100, height: 60))
    scene.backgroundColor = .clear
    scene.addChild(particleNode)
    return scene
  }
  
  var body: some View {
    VStack(spacing: 4.0) {
      ZStack {
        Image(viewModel.imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .layoutPriority(10)
        if let scene = castleScene {
          SpriteView(scene: scene, options: [.allowsTransparency])
        }
      }
      Text(viewModel.name)
        .font(.title2)
      VStack(spacing: 2.0) {
        HStack {
          Spacer()
          HStack {
            Image("sword_side")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .layoutPriority(-1)
            Text(viewModel.attack)
          }
          Spacer()
          HStack {
            Image("shield")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .layoutPriority(-1)
            Text(viewModel.defense)
          }
          Spacer()
        }
        .padding(.horizontal)
        HStack {
          HStack {
            Image(systemName: "suit.heart.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .layoutPriority(-1)
              .foregroundColor(Color(.systemRed))
            Text(viewModel.hp)
          }
        }
      }
    }
  }
}

struct CastleCell_Previews: PreviewProvider {
  static var previews: some View {
    CastleCell(
      viewModel: CastleViewModel(id: "1", name: "Winterfell", imageName: "castle1",
                                 attack: "100", defense: "100", hp: "100", condition: .normal)
    )
  }
}
