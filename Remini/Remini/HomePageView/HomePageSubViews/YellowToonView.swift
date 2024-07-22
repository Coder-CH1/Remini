//
//  YellowToonView.swift
//  Remini_
//
//  Created by Mac on 31/05/2024.
//

import SwiftUI
import Photos
import PhotosUI

struct YellowToonView: View {
//    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.backgroundColor = .black
//        UINavigationBar.appearance().standardAppearance = appearance
//    }
    @StateObject var imageDataArray = SelfieData()
    @State var showBottomButton = false
    @State var scrollViewOffset: CGFloat = 0
    @State var scrollViewContentOffset: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var showHomePageView = false
    @State var showAIPhotosView = false
    @State var selectedImages: [UIImage]
    var headerStr = "Yellow Toon"
    let columns = [
        GridItem(.flexible(), spacing: 20, alignment: .center),
        GridItem(.flexible(), spacing: 20, alignment: .center)
    ]
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    Section(header: VStack(spacing: 20) {
                        TopHeaderContent()
                        VStack {
                            Text(headerStr)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) +
                            Text(Image(systemName: "sun.max"))
                                .font(.system(size: 20))
                                .foregroundColor(.orange)
                        }
                        
                        HeaderContents(showAIPhotosView: $showAIPhotosView)
                    }) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(imageDataArray.selfieData, id: \.id) { index in
                                YellowToonCellView(imageData: index)
                            }
                        }
                    }
                    .offsetChanged(scrollViewOffset: $scrollViewOffset)
                    .contentOffsetChanged(scrollViewContentOffset: $scrollViewContentOffset)
                }
                .onChange(of: scrollViewOffset) { offset in
                    if offset < 50 {
                        withAnimation {
                            showBottomButton = true
                        }
                    } else {
                        withAnimation {
                            showBottomButton = false
                        }
                    }
                }
                if showBottomButton {
                    HStack(spacing: 30) {
                        Button { showAIPhotosView.toggle() } label: {
                            Text("Get Full Park")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                        }
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .fullScreenCover(isPresented: $showAIPhotosView) {
                                AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width/1.2, height: 50)
                    .background(.white)
                    .cornerRadius(25)
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 50)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.1)
            .background(Color.black.ignoresSafeArea())
            
            .navigationBarBackButtonHidden(false)
            .navigationBarItems(leading: Button {
                showHomePageView.toggle()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }.fullScreenCover(isPresented: $showHomePageView) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
            })
            .fullScreenCover(isPresented: $showAIPhotosView) {
                AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
            }
        }
    }
}

struct YellowToonView_Previews: PreviewProvider {
    static var previews: some View {
        YellowToonView(selectedImages: [UIImage()])
    }
}

extension View {
    func offsetChanged(scrollViewOffset: Binding<CGFloat>) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .named("scrollView")).minY)
                }
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    scrollViewOffset.wrappedValue = value
        })
    }
    
    func contentOffsetChanged(scrollViewContentOffset: Binding<CGFloat>) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .named("scrollView")).minY)
                }
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    scrollViewContentOffset.wrappedValue = value
        })
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct YellowToonCellView: View {
    var imageData: SelfieDataModel
    var body: some View {
        ZStack {
            Image(imageData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/2, height: 250)
                .background(.red)
                .cornerRadius(10)
                .padding(.leading, 3)
                .padding(.trailing, 3)
            ZStack {
                Button {
                    
                } label: {
                    HStack {
                        Text("Use this")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: UIScreen.main.bounds.width/4, height: 50)
                    .background(.black)
                    .cornerRadius(25)
                }
            }
            .padding(.top, 170)
            .padding(.trailing, -60)
        }
    }
}

struct HeaderContents: View {
    @Binding var showAIPhotosView: Bool
    var body: some View {
        VStack {
            Text("Get your personalized characters now!")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
            HStack(spacing: 30) {
                Button {
                    showAIPhotosView.toggle()
                } label: {
                    Text("Get Full Park")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width/1.2, height: 50)
            .background(.white)
            .cornerRadius(25)
        }
    }
}

struct TopHeaderContent: View {
    var body: some View {
        VStack {
            Text("6 PHOTOS")
                .background(Rectangle().fill(.gray))
                .frame(width: UIScreen.main.bounds.width/3.2, height: 40)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .background(.gray)
                .cornerRadius(10)
        }
    }
}
