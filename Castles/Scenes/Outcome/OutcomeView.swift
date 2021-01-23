//
//  OutcomeView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-23.
//

import SwiftUI

struct OutcomeView: View {
  let viewModel: OutcomeViewModel
  @Binding var isPresented: Bool
  
  init(outcome: Outcome, isPresented: Binding<Bool>) {
    self.viewModel = OutcomeViewModel(outcome: outcome)
    self._isPresented = isPresented
    self.entries = viewModel.getEntries()
  }
  
  private let entries: [OutcomeEntryType]
  
  var body: some View {
    
    NavigationView {
      VStack(spacing: 20) {
        ForEach(0 ..< entries.count, id: \.self) { index in
          entryView(for: entries[index])
        }
        Spacer()
      }
      .navigationTitle(viewModel.title)
      .padding(.vertical)
      .navigationBarItems(leading:
                            Button(action: { self.isPresented.toggle() }, label: {
                              Image(systemName: "xmark")
                            })
      )
    }
  }
  
  @ViewBuilder
  func entryView(for entry: OutcomeEntryType) -> some View {
    switch entry {
    case let .castleDestroyed(text):
      Text(text)
    case let .affectedCastle(imageName, text):
      imageTextSack(text: text, imageName: imageName, isIcon: false)
    case let .attackChange(value):
      imageTextSack(text: value, imageName: "sword_side", isIcon: false)
    case let .defenseChange(value):
      imageTextSack(text: value, imageName: "shield", isIcon: false)
    case let .hpChange(value):
      imageTextSack(text: value, imageName: "suit.heart.fill", isIcon: true)
    case let .loot(value: change):
      imageTextSack(text: change, imageName: "gold", isIcon: false)
    }
  }
  
  @ViewBuilder
  func imageTextSack(text: String, imageName: String, isIcon: Bool) -> some View {
    HStack {
      Text(text)
      (isIcon ? Image(systemName: imageName) : Image(imageName))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 60)
        .foregroundColor(.red)
    }
  }
}


struct OutcomeView_Previews: PreviewProvider {
  static var previews: some View {
    let castle = Castle(castleID: "1", imageName: "castle3", name: "Winterfell")
    return OutcomeView(outcome: Outcome.plunder(castle: castle, defenseDecrease: 23, hpDecrease: 42, isCastleDestroyed: true), isPresented: .constant(false))
  }
}
