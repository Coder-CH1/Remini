//
//  VideosLibraryView.swift
//  Remini_
//
//  Created by Mac on 18/07/2024.
//

import SwiftUI
import Photos
import UIKit
import PhotosUI
import AVKit

struct VideosLibraryView: View {
    @Binding var selectedVideos: [PHAsset]
    let sectionZeroRows = [
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    var body: some View {
        VStack {
//            ScrollView(.horizontal) {
//                LazyHGrid(rows: sectionZeroRows, spacing: 5) {
//                    ForEach(selectedVideos, id: \.self) { video in
//                        //VideosLibraryCell(video: video)
//                    }
//                }
//                .frame(height: 250)
//            }
//            .scrollIndicators(.hidden)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.black)
    }
}

struct VideosLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        VideosLibraryView(selectedVideos: .constant([PHAsset()]))
    }
}

struct VideosLibraryCell: View {
    @State var play: AVPlayer?
    let video: PHAsset
    func fetchVideo() {
        let manager = PHImageManager.default()
            .requestPlayerItem(forVideo: video, options: nil) { playerItem, _ in
                DispatchQueue.main.async {
                    if let playerItem = playerItem {
                        self.play = AVPlayer(playerItem: playerItem)
                        self.play?.play()
                    }
                }
            }
      }
    var body: some View {
        VStack {
            if let play = play {
                VideoPlayer(player: play)
                    .scaledToFit()
                    .frame(height: 200)
            }
        }
//        .onAppear() {
//            fetchVideo()
//        }
    }
}


//struct VideoPicker: UIViewControllerRepresentable{
//    @Binding var videoURL:String?
//
//func makeUIViewController(context: Context) -> PHPickerViewController {
//
//        var config = PHPickerConfiguration()
//        config.filter = .videos
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//class Coordinator:NSObject, PHPickerViewControllerDelegate{
//
//let parent:VideoPicker
//init(_ parent: VideoPicker){
//     self.parent = parent
//}
//
//func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//picker.dismiss(animated: true) {
//}
//
//}
//}
//}

