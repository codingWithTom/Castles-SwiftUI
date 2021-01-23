//
//  ActionCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI

struct ActionCell: View {
  let viewModel: ActionViewModel
  
  var body: some View {
      VStack {
        Image(systemName: viewModel.imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.blue)
          .layoutPriority(10)
        Text(viewModel.name)
          .font(.title3)
        HStack {
          Text(viewModel.price)
            .font(.title2)
          Image("gold")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .layoutPriority(-1)
        }
      }
  }
}

struct ActionCell_Previews: PreviewProvider {
  static var previews: some View {
    ActionCell(viewModel: ActionViewModel(price: "1,000", name: "Add Castle", imageName: "plus.circle"))
  }
}
