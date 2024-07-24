//
//  TransformedImageView.swift
//  Remini_
//
//  Created by Mac on 17/06/2024.
//

import SwiftUI
import UIKit
import Photos
import CoreML
import Vision

struct TransformedImageView: View {
    @Binding var selectedImages: [UIImage]
    @State var filteredImages: [UIImage] = []
    let columns = [
        GridItem(.flexible(), spacing: 20, alignment: .center),
        GridItem(.flexible(), spacing: 20, alignment: .center),
        GridItem(.flexible(), spacing: 20, alignment: .center),
        GridItem(.flexible(), spacing: 20, alignment: .center),
    ]
    var body: some View {
        VStack {
            HStack {
                Text("AI Transformed images")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)
            }
            Spacer()
                .frame(height: 300)
            HStack {
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(selectedImages, id: \.self) { index in
                            Image(uiImage: index)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width/2, height: 400)
                                .cornerRadius(10)
                                .clipped()
                        }
                        
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.black).ignoresSafeArea()
    }
}

struct TransformedImageView_Previews: PreviewProvider {
    static var previews: some View {
        TransformedImageView(selectedImages: .constant([UIImage()]))
    }
}

struct FilteredPickForTwoView: View {
    @Binding var selectedImage1: UIImage?
    @Binding var selectedImage2: UIImage?
    @State var combinedImage: UIImage?
    
    var body: some View {
        VStack {
            Text("AI Transformed images")
                .font(.system(size: 30, weight: .black))
                .foregroundColor(.white)
            HStack(spacing: 30) {
                if let image1 = selectedImage1 {
                    Image(uiImage: image1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width/2.5, height: 300)
                        .cornerRadius(10)
                }
                if let image2 = selectedImage2 {
                    Image(uiImage: image2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width/2.5, height: 300)
                        .cornerRadius(10)
                }
            }
            .padding(.all)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.black).ignoresSafeArea()
        .onAppear() {
            
        }
    }
}

struct EnhancedModalImage: View {
    @Binding var image: UIImage
    @State var filteredImage: UIImage?
    @State var isSaved: Bool = false

    func saveFilteredImageToPhotoLib() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.isSaved = true
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("AI Transformed images")
                .font(.system(size: 30, weight: .black))
                .foregroundColor(.white)
            if let enhancedImage = filteredImage {
                Image(uiImage: enhancedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 100)
            } else {
                ProgressView("Enhancing image...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.black)
        .onAppear() {

            }
        }
    }

