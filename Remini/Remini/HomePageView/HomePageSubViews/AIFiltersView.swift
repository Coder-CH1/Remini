//
//  AIFiltersView.swift
//  Remini_
//
//  Created by Mac on 25/05/2024.
//

import SwiftUI
import Photos
import PhotosUI

struct AIFiltersLoadingView: View {
    @State var selectedImages = [Image]()
    @State var selectedItems = [PhotosPickerItem]()
    @State var showImagePickerView = false
    @State var selectedImage: [UIImage]
    @State var showNewView = false
    @State var isLoading = false
    @State var showNextScreen = false
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
            Button {
                showNewView.toggle()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .fullScreenCover(isPresented: $showNewView) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
            }
        }
            .padding(.top, -350)
            .foregroundColor(.white)
            .offset(x: UIScreen.main.bounds.width / 2.5, y: UIScreen.main.bounds.height / 2.4)
            VStack {
                HStack {
                    Text("Generate\nYour Photos\n with AI")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .lineSpacing(15)
                }
                .padding(.leading, -140)
                Spacer()
                    .frame(height: 40)
                VStack(spacing: 25) {
                    Image("img2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .cornerRadius(60)
                    Text("This is you")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.leading, 250)
                Spacer()
                    .frame(height: 20)
                VStack {
                    Text("Your photos,\ngenerated with AI:")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.gray)
                        .lineLimit(10)
                }
                .padding(.trailing, 250)
                Spacer()
                    .frame(height: 20)
                HStack {
                    Image("img3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width/2, height: 150)
                        .background(.red)
                        .cornerRadius(20)
                    Image("img4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width/2, height: 150)
                        .background(.red)
                        .cornerRadius(20)
                }
                Spacer()
                    .frame(height: 40)
                HStack {
                        PhotosPicker(
                            selection: $selectedItems,
                            matching: .images) {
                    Button {
                        showImagePickerView.toggle()
                    } label: {
                        HStack(spacing: 30) {
                            Text("Upload Photo")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                    }
                    .fullScreenCover(isPresented: $showImagePickerView) {
                        AIFiltersImagePicker(selectedImage: $selectedImage, selectedImages: $selectedImages, showNextScreen: $showNextScreen)
                    }
                    .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                    .background(.white)
                    .cornerRadius(30)
                }
                }
            }
            if isLoading {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
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
            } else {
                
            }
        }
        .onAppear() {
            startLoading()
        }
    }
    func startLoading() {
        isLoading = true
        withAnimation(.linear(duration: 1.5).repeatForever()) {
            self.rotatingAngle = 360.0
        }
        rotatingAngle = 360.0
        trimAmount = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                isLoading = false
            }
        }
    }
}

struct AIFiltersLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AIFiltersLoadingView(selectedImage: [UIImage()])
    }
}

struct AIFiltersImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: [UIImage]
    @Binding var selectedImages: [Image]
    @Binding var showNextScreen: Bool
    
    func makeUIViewController(context: Context) ->  PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, selectedImages: $selectedImages, showNextScreen: $showNextScreen)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var selectedImage: [UIImage]
        @Binding var selectedImages: [Image]
        @Binding var showNextScreen: Bool
        init(selectedImage: Binding<[UIImage]>, selectedImages: Binding<[Image]>, showNextScreen: Binding<Bool>) {
            self._selectedImage = selectedImage
            self._selectedImages = selectedImages
            self._showNextScreen = showNextScreen
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                picker.dismiss(animated: true)
            } else {
                for result in results {
                    if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                            if let error = error {
                                print("Error loading image: \(error.localizedDescription)")
                            } else if let image = image as? UIImage {
            self?.selectedImage.append(image)
            //self?.selectedImages.append(Image(uiImage: image))
            self?.selectedImages.append(Image(uiImage: image))
            self?.showNextScreen = true
            DispatchQueue.main.async {
                let transformAIView = AITransformationLoadingView(selectedImages: self?.$selectedImage ?? .constant([UIImage()]), isActive: true)
                let hosting = UIHostingController(rootView: transformAIView)
                picker.present(UIHostingController(rootView: transformAIView), animated: true)
                hosting.modalPresentationStyle = .fullScreen
                picker.present(hosting, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
}
