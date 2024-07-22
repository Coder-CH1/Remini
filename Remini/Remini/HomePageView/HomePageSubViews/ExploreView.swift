//
//  ExploreView.swift
//  Remini_
//
//  Created by Mac on 25/05/2024.
//

import SwiftUI
import Photos
import PhotosUI

struct ExploreView: View {
    @StateObject var imageDataArray = Data()
    @State var selectedImg: Image
    @State var selectedImage: [UIImage]
    @State var showNewView = false
    @State var showNextScreen = false
    let columns = [GridItem(.flexible(), spacing: 10)]
    var body: some View {
        VStack {
            HStack() {
                HStack {
                    Button(action: {
                        print("btn tapped")
                        showNewView.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, -80)
                .fullScreenCover(isPresented: $showNewView) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
                }
                Text("Explore All Features")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    ForEach(imageDataArray.imageData, id: \.id) { index in
                        ExploreCellView(selectedImg: selectedImg, imageData: index, selectedImage: selectedImage)
                    }
                }
                .padding(.top, 30)
                .background(Color(red: 0.2, green: 0.1, blue: 0.1))
                .cornerRadius(30)
            }
            .scrollIndicators(.hidden)
            .padding(.vertical, 10)
        }
        .background(.black)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView(selectedImg: Image(systemName: ""), selectedImage: [UIImage()])
    }
}

struct ExploreCellView: View {
    @State var showNextScreen = false
    @State var selectedImg: Image
    @State var selectedItems: PhotosPickerItem?
    var imageData: AppDataModel
    @State var showImagePickerView = false
    @State var selectedImage: [UIImage]
    @State var isTapped: Bool = false
    let screenSize = UIScreen.main.bounds.size
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(imageData.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .cornerRadius(45)
                Text(imageData.text2)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images) {
                        Button(action: {
                            showImagePickerView.toggle()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                    }
                }
            }
            .padding(.trailing, 20)
            .fullScreenCover(isPresented: $showImagePickerView) {
                ExploreImagePicker(selectedImage: $selectedImage, selectedImg: $selectedImg, showNextScreen: $showNextScreen)
            }
            .frame(width: screenSize.width, height: UIScreen.main.bounds.height/8)
            .background(.secondary)
            .cornerRadius(30)
        }
    }
}

struct ExploreImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: [UIImage]
    @Binding var selectedImg: Image
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
        Coordinator(selectedImage: $selectedImage, selectedImg: $selectedImg, showNextScreen: $showNextScreen)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var selectedImage: [UIImage]
        @Binding var selectedImg: Image
        @Binding var showNextScreen: Bool
        
        init(selectedImage: Binding<[UIImage]>, selectedImg: Binding<Image>, showNextScreen: Binding<Bool>) {
            self._selectedImage = selectedImage
            self._selectedImg = selectedImg
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
            self?.selectedImg = Image(uiImage: image)
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
