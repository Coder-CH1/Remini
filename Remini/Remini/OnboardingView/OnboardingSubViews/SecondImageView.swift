//
//  SecondImageView.swift
//  Remini_
//
//  Created by Mac on 23/05/2024.
//

import SwiftUI

struct SecondImageView: View {
    @State var isPresentedView = false
    @State var offset: CGFloat = 0
    @State var dragging = false
    @GestureState var dragOffset: CGSize = .zero
    var body: some View {
        ZStack {
            GeometryReader { g in
                ZStack {
                    VStack {
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
                .position(x: 20, y: g.size.height/2)
                .offset(x: offset, y: 0)
                .gesture(DragGesture() .onChanged { gesture in
                        offset = gesture.translation.width
                }
                    .onEnded { _ in
                        offset = 0
                    })
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
                        Text("Transform into \n a video game")
                            .font(.system(size: 34, weight: .black))
                            .foregroundColor(.white)
                        Button {
                            print("btn tapped")
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
                        ThirdImageView()
                }
            }
        }
        .background(
        Image("img6")
            .resizable()
            .aspectRatio(contentMode: .fill)
        .ignoresSafeArea())
    }
}
struct SecondImageView_Previews: PreviewProvider {
    static var previews: some View {
        SecondImageView()
    }
}

