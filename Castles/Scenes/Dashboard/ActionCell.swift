//
//  ActionCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI

struct ActionCell: View {
  let viewModel: ActionViewModel
  
  var image: Image {
    viewModel.isIcon ? Image(systemName: viewModel.imageName) : Image(viewModel.imageName)
  }
  
  init(viewModel: ActionViewModel) {
    self.viewModel = viewModel
  }
  
  var progressView: some View {
    ProgressView(startDate: viewModel.startDate ?? Date(),
                 endDate: viewModel.endDate ?? Date())
  }
  
  var body: some View {
    ZStack {
      VStack {
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.blue)
            .layoutPriority(10)
          Text(viewModel.name)
            .font(.title3)
          HStack {
            Text(viewModel.value)
              .font(.title2)
            Image(viewModel.effectImageName)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .layoutPriority(-1)
          }
      }
      if viewModel.startDate != nil {
        progressView
          .overlay(
            VStack {
              Spacer()
              HStack {
                Spacer()
                Button(action: { viewModel.startActivity() }) {                
                  Image(systemName: "livephoto")
                    .resizable()
                    .scaledToFit()
                }
                  .tint(.green)
                Spacer()
              }
              Spacer()
            }
          )
      }
    }
  }
}

struct ActionCell_Previews: PreviewProvider {
  static var previews: some View {
    ActionCell(viewModel: ActionViewModel(id: "preview", value: "1,000", name: "Add Castle", imageName: "plus.circle", isIcon: true, effectImageName: "gold", startDate: nil, endDate: nil, startActivity: { }))
  }
}
