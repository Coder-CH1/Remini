//
//  ThirdImageView.swift
//  Remini_
//
//  Created by Mac on 24/05/2024.
//

import SwiftUI
import Photos
//import Kingfisher

struct ThirdImageView: View {
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
                .position(x: 0, y: g.size.height/2)
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
                    Text("Meet the new \n you")
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
                    LoadingView(isActive: true)
                }
            }
        }
        .background(
        Image("img3")
            .resizable()
            .aspectRatio(contentMode: .fill)
        .ignoresSafeArea())
    }
}
struct ThirdImageView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdImageView()
    }
}

struct LoadingView: View {
    @State var isPresentedView = false
    @State var isActive: Bool
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    var body: some View {
        VStack {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
        .onAppear{
            self.rotatingAngle = 360.0
            self.trimAmount = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.isActive = true
                    isPresentedView.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentedView) {
            GiveAccessView()
        }
        .background(.black)
        .ignoresSafeArea()
    }
}

struct GiveAccessView: View {
    @StateObject var imageDataArray = CoupleData()
    @State var showNewView = false
    @State var showImages = false
    @StateObject var appImageModel = CoupleData()
    let columns = [
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    func getOffsetX(_ index: Int) -> CGFloat {
        if index == 0 || index == 1 {
            return 0
        } else if index == 2 || index == 3 {
            return index == 2 ? -10 : 100
        } else {
            return -100
        }
    }
    func getOffsetY(_ index: Int) -> CGFloat {
        if index == 0 || index == 1 {
            return 0
        } else if index == 2 || index == 3 {
            return -100
        } else {
            return 100
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 50) {
                ForEach(imageDataArray.coupleData, id: \.id) { index in
                    GiveAccessCellView(imageData: index)
                        .frame(width: 100, height: 100)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .offset(x: showImages ? 0 : getOffsetX(Int(1)), y: showImages ? 0 : getOffsetY(Int(3)))
                        .animation(.easeInOut(duration: 3.0))
                }
            }
            .frame(height: 200)
            HStack(alignment: .center, spacing: 20) {
                Text("Get the most out of\nRemini ")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white) + Text(
                        Image(systemName: "football.fill"))
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.pink)
            }
            .padding(.leading, -40)
            Text("To continue, Remini needs access to your photos. \nYou can change this later in the settings app.")
                .font(.system(size: 15))
                .foregroundColor(.white)
            Button {
                print("btn tapped")
                showNewView.toggle()
            } label: {
                Text("Give Access to Photos")
                    .frame(width: UIScreen.main.bounds.width/1.1, height: 60)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(30)
            }
            .fullScreenCover(isPresented: $showNewView) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
            }
            Button {
                print("btn tapped")
            } label: {
                Text("I'll do it later")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .underline(color: .white)
            }
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

struct GiveAccessCellView: View {
    var imageData: CoupleDataModel
    var body: some View {
        Image(imageData.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 120)
    }
}
