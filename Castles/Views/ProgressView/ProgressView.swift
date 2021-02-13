//
//  ProgressView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import SwiftUI

struct ProgressView: View {
  let viewModel: ProgressViewModel
  @Binding var showingProgressView: Bool
  
  init(startDate: Date, endDate: Date, showingProgressView: Binding<Bool>) {
    self.viewModel = ProgressViewModel(startDate: startDate, endDate: endDate)
    self._showingProgressView = showingProgressView
  }
  
  var body: some View {
    GeometryReader { geometry in
      let size = geometry.size.width / 2
      ProgressCircle(progress: viewModel.progress)
        .stroke(Color.blue, lineWidth: size * 0.1)
        .frame(width: size, height: size)
    }
    .onReceive(viewModel.$isComplete, perform: {
      showingProgressView = !$0
    })
  }
}

private struct ProgressCircle: Shape {
  let progress: Double
  
  func path(in rect: CGRect) -> Path {
    let bezierPath = UIBezierPath()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let startAngle: CGFloat = .pi * 3 / 2
    let endAngle: CGFloat = startAngle - (2 * .pi) * CGFloat(progress)
    bezierPath.addArc(withCenter: center, radius: rect.width * 0.9 / 2, startAngle: startAngle,
                endAngle: endAngle, clockwise: true)
    let path = Path(bezierPath.cgPath)
    
    return path
      
  }
}

struct ProgressView_Previews: PreviewProvider {
  static var previews: some View {
    ProgressView(startDate: Date().addingTimeInterval(-10),
                 endDate: Date().addingTimeInterval(10),
                 showingProgressView: .constant(true))
  }
}
