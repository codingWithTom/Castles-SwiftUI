//
//  DashboardView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI

private enum DashboardState {
  case attacking
  case fortifying
  case waitingForBarbarian
  case waitingForPlayer
  
  var isPlayerState: Bool {
    switch self {
    case .attacking, .fortifying, .waitingForPlayer:
      return true
    default:
      return false
    }
  }
}

enum DashboardSheet {
  case shop, outcome
}

struct DashboardView: View {
  @ObservedObject private var viewModel = DashboardViewModel()
  
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  private var topBarHeight: CGFloat { return 50 }
  @State private var state: DashboardState = .waitingForPlayer
  @State private var isPresentingSheet = false
  @State private var isPresentingErrorAlert = false
  @State private var outcome: Outcome?
  
  var gridItems: [GridItem] {
    if verticalSizeClass == .regular {
      return Array(repeating: GridItem(.flexible(minimum: 250)), count: 2)
    } else {
      return [GridItem(.flexible(minimum: 220))]
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .top) {
        dashboard
        
        actionView
        .padding(.top, 30)
      }
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Button(action: {
            self.viewModel.tappedShop()
            self.isPresentingSheet.toggle()
          } , label: {
            Text("Shop")
          })
        }
      }
      .navigationTitle("Kingdom")
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onReceive(viewModel.$turns, perform: { turns in
      guard let firstTurn = turns.first else { return }
      state = firstTurn.isPlayerTurn ? .waitingForPlayer : .waitingForBarbarian
    })
    .onReceive(viewModel.$outcome, perform: {
      guard let outcome = $0 else { return }
      self.outcome = outcome
      self.isPresentingSheet = true
    })
    .onReceive(viewModel.$errorMessage, perform: {
      self.isPresentingErrorAlert = $0 != nil
    })
    .sheet(isPresented: $isPresentingSheet, content: {
      switch viewModel.dashboardSheet {
      case .shop:
        ShopView(isPresenting: $isPresentingSheet)
      case .outcome:
        if let outcome = self.outcome {
          OutcomeView(outcome: outcome, isPresented: $isPresentingSheet)
        } else {
          EmptyView()
        }
      }
    })
    .alert(isPresented: $isPresentingErrorAlert, content: {
      Alert(title: Text(viewModel.errorMessage?.title ?? ""),
            message: Text(viewModel.errorMessage?.message ?? ""),
            dismissButton: .default(Text("OK")))
    })
  }
  
  var dashboard: some View {
    VStack {
      topView
        .frame(height: topBarHeight)
      ScrollView(.horizontal) {
        LazyHGrid(rows: gridItems) {
          ForEach(viewModel.items) { cell in
            switch cell {
            case .action(let actionViewModel):
              ActionCell(viewModel: actionViewModel)
                .onTapGesture {
                  viewModel.userDidTapAddCastle()
                }
            case .castle(let castleViewModel):
              CastleCell(viewModel: castleViewModel)
                .onTapGesture {
                  self.tappedCaslte(withID: castleViewModel.id)
                }
            }
          }
        }
      }
      Spacer()
    }
  }
  
  var actionView: some View {
    HStack {
      Spacer()
      if state.isPlayerState {
        ActionView(imageName: "sword", isSelected: state == .attacking)
          .frame(width: topBarHeight * 1.25, height: topBarHeight * 1.25)
          .onTapGesture { withAnimation { state = .attacking } }
        ActionView(imageName: "shield", isSelected: state == .fortifying)
          .frame(width: topBarHeight * 1.25, height: topBarHeight * 1.25)
          .onTapGesture { withAnimation { state = .fortifying } }
      } else {
        Text("Next")
          .font(.title3)
          .foregroundColor(.white)
          .frame(width: topBarHeight * 1.25, height: topBarHeight * 1.25)
          .background(Color.black)
          .clipShape(Circle())
          .onTapGesture { withAnimation { viewModel.userSelectedNextTurn() } }
      }
      Spacer()
    }
  }
  
  var topView: some View {
    HStack {
      HStack(alignment: .center) {
        Image("gold")
          .resizable()
          .aspectRatio(contentMode: .fit)
        Text(viewModel.goldAmount)
      }.padding(.horizontal)
      Spacer()
      HStack(spacing: 4.0) {
        ForEach(0 ..< viewModel.turns.count, id: \.self) { index in
          let turn = viewModel.turns[index]
          Rectangle()
            .fill(Color(turn.color))
            .frame(width: 20)
            .overlay( Rectangle().stroke() )
        }
      }
    }
  }
  
  func tappedCaslte(withID castleID: String) {
    if state == .attacking {
      viewModel.userSelectedCastleForAttack(castleID: castleID)
    } else if state == .fortifying {
      viewModel.userSelectedCastleForFortification(castleID: castleID)
    }
  }
}

struct ActionView: View {
  let imageName: String
  let isSelected: Bool
  
  var body: some View {
    Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .background(Color.black)
      .clipShape(Circle())
      .overlay(Circle()
                .stroke(lineWidth: isSelected ? 4.0 : 0.0)
                .foregroundColor(.blue))
  }
}

struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView()
  }
}
