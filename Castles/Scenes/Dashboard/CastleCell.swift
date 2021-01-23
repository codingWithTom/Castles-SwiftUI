//
//  CastleCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-19.
//

import SwiftUI

struct CastleCell: View {
  let viewModel: CastleViewModel
  
  var body: some View {
    VStack(spacing: 4.0) {
      Image(viewModel.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .layoutPriority(10)
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
                                 attack: "100", defense: "100", hp: "100")
    )
  }
}
