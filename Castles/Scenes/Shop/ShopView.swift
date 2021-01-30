//
//  ShopView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-23.
//

import SwiftUI

struct ShopView: View {
  @ObservedObject private var viewModel = ShopViewModel()
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @Binding var isPresenting: Bool
  @State private var isPresentingCastleOptions: Bool = false
  @State private var selectedItemID: String?
  @State private var isPresentingErrorAlert = false
  
  var gridItems: [GridItem] {
    if verticalSizeClass == .regular {
      return Array(repeating: GridItem(.flexible(minimum: 200)), count: 2)
    } else {
      return [GridItem(.flexible(minimum: 220))]
    }
  }
  
  var sheetButtons: [ActionSheet.Button] {
    let castleButtons: [ActionSheet.Button] = viewModel.castleNames.enumerated().map { index, name in
      .default(Text(name),
               action: {
                guard let itemID = selectedItemID else { return }
                viewModel.selectedCastle(castleIndex: index, for: itemID)
               })
    }
    return castleButtons + [.cancel()]
  }
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .topLeading) {
        ScrollView(.horizontal) {
          LazyHGrid(rows: gridItems) {
            ForEach(0 ..< viewModel.items.count, id: \.self) { index in
              let item = viewModel.items[index]
              ShopItemView(viewModel: item)
                .padding()
                .onTapGesture {
                  guard viewModel.isItemForCastle(itemID: item.itemID) else { return }
                  withAnimation {
                    isPresentingCastleOptions = true
                    selectedItemID = item.itemID
                  }
                }
            }
          }
        }
        if isPresentingCastleOptions {
          Image("castle1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(width: 60, height: 60)
            .background(Color.blue)
            .clipShape(Circle())
            .actionSheet(isPresented: $isPresentingCastleOptions, content: {
              ActionSheet(title: Text("Apply Item to Castle"), message: Text("To which castle shall the item be applied to?"),
                          buttons: sheetButtons)
            })
        }
      }
      .navigationTitle("Shop")
      .navigationBarItems(leading:
                            Button(action: { self.isPresenting = false }, label: {
                              Image(systemName: "xmark")
                            })
      )
      .alert(isPresented: $isPresentingErrorAlert, content: {
        Alert(title: Text(viewModel.errorMessage?.title ?? ""),
              message: Text(viewModel.errorMessage?.message ?? ""),
              dismissButton: .default(Text("Continue Shopping")))
      })
    }
    .onReceive(viewModel.$errorMessage, perform: {
      self.isPresentingErrorAlert = $0 != nil
    })
  }
}

private struct ShopItemView: View {
  let viewModel: ShopItemViewModel
  
  var body: some View {
    ZStack(alignment: .topLeading){
      VStack {
        (viewModel.isIcon ? Image(systemName: viewModel.imageName) : Image(viewModel.imageName))
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.blue)
          .blur(radius: viewModel.isAvailable ? 0.0 : 10)
        Text(viewModel.name)
          .font(.title)
        Spacer()
        HStack {
          Text(viewModel.price)
          Image("gold")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .layoutPriority(-1)
            .frame(maxHeight: 60)
        }
      }
      Text("\(viewModel.quantity)")
        .foregroundColor(.white)
        .padding()
        .background(Color.red)
        .clipShape(Circle())
    }
  }
}

struct ShopView_Previews: PreviewProvider {
  static var previews: some View {
    ShopView(isPresenting: .constant(false))
  }
}
