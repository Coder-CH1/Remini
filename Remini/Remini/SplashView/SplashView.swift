//
//  SplashView.swift
//  Remini_
//
//  Created by Mac on 21/05/2024.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    var body: some View {
        Color.black.ignoresSafeArea()
            .overlay(
                VStack(spacing: 0) {
                    Image("reminiLogo")
                            .resizable()
                            .frame(width: 300, height: 300)
                        Circle()
                            .trim(from: trimAmount, to: 1)
                            .stroke(
                                Color.white,
                                style:
                                    StrokeStyle(lineWidth: 5, lineCap:
                                            .round, lineJoin:
                                            .round, miterLimit:
                                            .infinity, dashPhase: 0))
                            .frame(width: 20, height: 20)
                            .rotationEffect(.degrees(rotatingAngle))
                            .animation(.linear(duration: 1.5).repeatForever(), value: rotatingAngle)
                     }
                    .onAppear{
                        self.rotatingAngle = 360.0
                        self.trimAmount = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                    .background(.black)
                    .ignoresSafeArea()
        )
    }
}
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(false))
    }
}
