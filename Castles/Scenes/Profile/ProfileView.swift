//
//  ProfileView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-07.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
      ZStack {
        Rectangle()
          .fill(Color.white)
        VStack {
          Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundColor(Color(.sRGB, red: 0, green: 57 / 256, blue: 18 / 256, opacity: 1.0))
            .frame(width: 200, height: 200)
          Spacer()
          Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("Sign Out")
              .foregroundColor(.red)
              .font(.largeTitle)
          })
        }
        .padding()
      }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
