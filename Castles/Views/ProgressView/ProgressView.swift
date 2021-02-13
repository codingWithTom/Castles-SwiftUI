//
//  ProgressView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import SwiftUI

struct ProgressView: View {
  @ObservedObject private var viewModel: ProgressViewModel
  
  init(startDate: Date, endDate: Date) {
    self.viewModel = ProgressViewModel(startDate: startDate, endDate: endDate)
  }
  
  var body: some View {
    if viewModel.isComplete {
      EmptyView()
    } else {
      ProgressCircle(progress: viewModel.progress)
        .stroke(Color.blue, lineWidth: 10)
        .background(Color(UIColor.white.withAlphaComponent(0.6)))
    }
  }
}

private struct ProgressCircle: Shape {
  let progress: Double
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let startAngle = Double.pi * 3 / 2
    let endAngle = startAngle - (2 * .pi) * progress
    let radius = min(rect.width, rect.height) / 2 * 0.9
    path.addArc(center: center, radius: radius, startAngle: .radians(startAngle), endAngle: .radians(endAngle), clockwise: true)
    
    return path
      
  }
}

struct ProgressView_Previews: PreviewProvider {
  static var previews: some View {
    ProgressView(startDate: Date().addingTimeInterval(-10),
                 endDate: Date().addingTimeInterval(10))
  }
}
