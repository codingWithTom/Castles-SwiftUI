//
//  SlideInView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-07.
//

import SwiftUI

struct SlideInView<RootView: View>: View {
  let rootView: RootView
  @Binding var isPresenting: Bool
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        rootView.frame(width: geometry.size.width * 0.7, height: geometry.size.height)
        Rectangle()
          .fill(Color(UIColor.black.withAlphaComponent(0.7)))
          .onTapGesture {
            withAnimation {
              self.isPresenting.toggle()
            }
          }
      }
    }
    .ignoresSafeArea()
  }
}

struct SlideInView_Previews: PreviewProvider {
  static var previews: some View {
    SlideInView(rootView: Text("Hello World"), isPresenting: .constant(true))
  }
}
