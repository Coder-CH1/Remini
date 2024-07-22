//
//  VideoDetailsView.swift
//  Remini_
//
//  Created by Mac on 05/07/2024.
//

import SwiftUI
import AVKit
import Photos

struct VideoDetailsView: View {
    @Binding var videoPlayer: AVPlayer
    @State var toogleBack = false
    @State var toogleToAIPhotos = false
    @State var selectedImages: [UIImage]
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                VideoPlayer(player: videoPlayer)
                    .aspectRatio(CGSize(width: UIScreen.main.bounds.width, height: 100.0), contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
                    .onAppear() {
                        videoPlayer.play()
                    }
                    .onDisappear() {
                        videoPlayer.pause()
                    }
                ZStack {
                    Button {
                        toogleBack.toggle()
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .fullScreenCover(isPresented: $toogleBack) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
                    }
                }
                .padding(.top, -420)
                .padding(.leading, -160)
            }
            VStack(spacing: 20) {
                Text("VIDEO")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width/5, height: 40)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .cornerRadius(10)
                HStack {
                    Text("Century of Fashion")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                          Image(systemName: "tshirt.fill")
                        .foregroundColor(.blue)
                }
                Text("Revive iconic styles with amazing video.")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
            }
            Spacer()
                .frame(height: 80)
            VStack {
                Button {
                    toogleToAIPhotos.toggle()
                } label: {
                    Text("Get Video")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                }
                .fullScreenCover(isPresented: $toogleToAIPhotos, content: {
                    AIFiltersLoadingView(selectedImage: selectedImages)
                })
                .frame(width: UIScreen.main.bounds.width/1.1, height: 60)
                .background(.white)
                .cornerRadius(30)
            }
            .padding(.bottom, 50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.black)
    }
}

struct VideoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailsView(videoPlayer: .constant(AVPlayer()), selectedImages: [UIImage()])
    }
}
