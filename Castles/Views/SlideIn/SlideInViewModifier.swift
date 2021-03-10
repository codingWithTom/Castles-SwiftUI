//
//  SlideInViewModifier.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-07.
//

import SwiftUI

struct SlideInViewModifier<RootView: View>: ViewModifier {
  let rootView: RootView
  @Binding var isPresenting: Bool
  
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      ZStack {
        content
          .zIndex(1.0)
        if isPresenting {
          SlideInView(rootView: rootView, isPresenting: $isPresenting)
            .zIndex(2.0)
            .transition(slideTransition(offset: -geometry.size.width))
        }
      }
    }
  }
  
  private func slideTransition(offset: CGFloat) -> AnyTransition {
    AnyTransition.modifier(active: OffsetModifier(offset: offset), identity: OffsetModifier(offset: 0))
  }
}

struct OffsetModifier: ViewModifier {
  let offset: CGFloat
  
  func body(content: Content) -> some View {
    content
      .offset(x: offset, y: 0)
  }
}
