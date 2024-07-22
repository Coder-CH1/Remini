//
//  FirstImageView.swift
//  Remini_
//
//  Created by Mac on 23/05/2024.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum Half {
    case left, right
}
struct FirstImageView: View {
    @State var isPresentedView = false
    @State var offset: CGFloat = 0
    @State var dragging = false
    @GestureState var dragOffset: CGSize = .zero
    let gradientLayer = CAGradientLayer()
    
    let half: Half = .right
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        VStack {
                            Text("Move the slider!")
                                .frame(width: 200, height: 60)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(30)
                            Button {
                                dragging = true
                            } label: {
                                Image(systemName: "arrow.left.and.right")
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .cornerRadius(25)
                                    .tint(.black)
                                    .offset(x: dragOffset.width, y: dragOffset.height)
                                    .gesture(DragGesture()
                                    .updating($dragOffset, body: { (value, state, _)  in
                                        offset += value.translation.width
                                        }
                                    )
                                        .onEnded({ _ in
                                            offset = 1
                                        })
                                )
                            }
                        }
                        .padding(.leading, UIScreen.main.bounds.width)
                    }
                    .frame(width: g.size.width,height: g.size.height)
                    .background(.white.opacity(0.2))
                    .position(x: 0, y: g.size.height/2)
                    .offset(x: offset, y: 0)
                    .gesture(DragGesture() .onChanged { gesture in
                            offset = gesture.translation.width
                    }
                        .onEnded { _ in
                            offset = 0
                        }
                    )
                }
            }
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.2)) {
                    offset = 100
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        offset = 0
                    }
                }
            }
            VStack {
                Spacer()
                HStack(spacing: 30) {
                    Text("Restore your \n old photos")
                .font(.system(size: 34, weight: .black))
                .foregroundColor(.white)
                    Button {
                        isPresentedView.toggle()
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(width: 80, height: 70)
                            .background(.white)
                            .cornerRadius(40)
                            .tint(.black)
                    }
                }
                .fullScreenCover(isPresented: $isPresentedView) {
                    SecondImageView()
                }
            }
        }
        .background(
            Image("img5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity, height: UIScreen.main.bounds.height, alignment: .center)
                .ignoresSafeArea())
    }
}
struct FirstImageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstImageView()
    }
}

