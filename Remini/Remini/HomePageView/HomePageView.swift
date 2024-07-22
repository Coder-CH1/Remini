//
//  HomePageView.swift
//  Remini_
//
//  Created by Mac on 24/05/2024.
//

import SwiftUI
import BottomSheetSwiftUI
import Photos
import PhotosUI
import SQLite3
import AVKit
import UIKit

struct HomePageView: View {
    @AppStorage("hasSeenModal") var hasSeenModal: Bool = false
    @StateObject var imageData = CoupleData()
    @StateObject var selfieData = SelfieData()
    @StateObject var oldData = OldImagesData()
    @State var selectedCellImage: UIImage
    @State var selectedImages: [UIImage]
    @State var uiImage: UIImage
    @State var showYellowToon = false
    @State var showDetailsView = false
    @State var showAIPhotosView = false
    @State var showAIPhotosViewTwo = false
    @State var showingModal = false
    @State var images: [PHAsset]
    @State var videos: [PHAsset]
    @State var selectedImage: UIImage
    @State var bottomSheetPosition: BottomSheetPosition = .hidden
    @State var showGenderSelector = false
    @State var selectedCoupleData: CoupleDataModel
    @State var selectedSelfieData: SelfieDataModel
    @State var selectedOldImgData: OldImagesDataModel
    @State var selected1: UIImage
    @State var selected2: UIImage
    @State var cellsImage: UIImage
    @State var showVideoDetailsView: Bool
    @State var showVideos = false
    @State var selectedVideo: AVPlayer
    var player: AVPlayer {
        AVPlayer(url: Bundle.main.url(forResource: "istockvideo", withExtension: "mp4")!)
    }
    func fetchPhotos() {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                    assets.enumerateObjects { (object,_, _) in
                        images.append(object)
                        videos.append(object)
                    }
                } else if status == .denied {
                    
                }
            }
        }
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TopNavHomePageView()
                MiddleHomePageView(selectedImages: $selectedImages, selectedCellImage: $selectedCellImage, img: $uiImage, showDetailsView: $showDetailsView, showingModal: $showingModal, showAIPhotosView: $showAIPhotosView, showYellowToolView: $showYellowToon, showAIPhotosViewTwo: $showAIPhotosViewTwo, selectedPhotos: $images, selectedVideos: $videos, selectededCoupleData: $selectedCoupleData, coupleData: $imageData.coupleData, selectededSelfieData: $selectedSelfieData, selfieData: $selfieData.selfieData, oldImagesData: $selectedOldImgData, oldImgData: $oldData.oldImgData, showVideoDetailsView: $showVideoDetailsView, selectedVideo: $selectedVideo, showVideos: $showVideos, video: player)
                BottomTabHomePageView(selectedImages: selectedImages)
            }
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition, switchablePositions: [.absolute(UIScreen.main.bounds.height/2)]) {
                    ChooseYourGenderBottomSheetView(dismissBottomSheet: {
                        bottomSheetPosition = .hidden
                    } )
            }
            .enableBackgroundBlur(true)
            .customBackground(Color.white.cornerRadius(30))
            .showDragIndicator(false)
            .onAppear() {
                if !hasSeenModal {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        bottomSheetPosition = .absolute(UIScreen.main.bounds.height/1.5)
                    hasSeenModal = true
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    fetchPhotos()
                }
            }
            .onAppear() {
                if !hasSeenModal {
                    hasSeenModal = false
                }
            }
            .onDisappear() {
                player.pause()
            }
            .fullScreenCover(isPresented: $showDetailsView) {
                DetailsView(showPickForTwo: Bool(), selected1: PHAsset(),selected2: PHAsset(),selectedImages: [Image(systemName: "")], selectedImage: UIImage(), image: UIImage(), selection1: $selectedCoupleData)
            }
            .fullScreenCover(isPresented: $showAIPhotosViewTwo) {
                AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
            }
            .fullScreenCover(isPresented: $showAIPhotosView) {
                AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
            }
            .fullScreenCover(isPresented: $showYellowToon) {
                YellowToonView(selectedImages: selectedImages)
            }
            .fullScreenCover(isPresented: $showVideoDetailsView) {
                VideoDetailsView(videoPlayer: $selectedVideo, selectedImages: selectedImages)
            }
            if $showingModal.wrappedValue {
                if let selectedImage = selectedCellImage {
                    ModalView(selectedImage: selectedImage, showingModal: $showingModal, dismissModal: {
                        showingModal = false
                    })
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
    }
}

struct TopNavHomePageView: View {
    @State var showPromoView = false
    @State var showSettingView = false
    @State var bottomSheetShown: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("Remini")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
                HStack(spacing: 15) {
                    Button {
                        showPromoView.toggle()
                    } label: {
                        Text("PRO")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }.fullScreenCover(isPresented: $showPromoView) {
                        PromoView()
                    }
                    .frame(width: 50, height: 40)
                    .background(.red)
                    .cornerRadius(35)
                    
                    Button {
                        showSettingView.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .fullScreenCover(isPresented: $showSettingView) {
                        SettingsView()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .background(.black)
    }
}

struct MiddleHomePageView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var selectedCellImage: UIImage
    @Binding var img: UIImage
    @Binding var showDetailsView: Bool
    @Binding var showingModal: Bool
    @Binding var showAIPhotosView: Bool
    @Binding var showYellowToolView: Bool
    @Binding var showAIPhotosViewTwo: Bool
    @Binding var selectedPhotos: [PHAsset]
    @Binding var selectedVideos: [PHAsset]
    @Binding var selectededCoupleData: CoupleDataModel
    @Binding var coupleData: [CoupleDataModel]
    @Binding var selectededSelfieData: SelfieDataModel
    @Binding var selfieData: [SelfieDataModel]
    @Binding var oldImagesData: OldImagesDataModel
    @Binding var oldImgData: [OldImagesDataModel]
    @Binding var showVideoDetailsView: Bool
    @Binding var selectedVideo: AVPlayer
    @State var showSeeAllSectionOneView = false
    @State var showSeeAllSectionThreeView = false
    @State var showYellowToon = false
    @State var showPhotoLibrary: Bool = false
    @State var permissionGranted: Bool = false
    @Binding var showVideos: Bool
    var video: AVPlayer
    let columns = [GridItem(.flexible(), spacing: 80, alignment: .center)]
    let rows = [
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    let sectionZeroRows = [
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
   
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    
                    //MARK: - Section Zero -
                    Section(header:  VStack(alignment: .leading, spacing: 20){ HStack(alignment: .center, spacing: 20) {
                        Text("Enhance")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)  + Text(
                                Image(systemName: "sparkles"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                    .padding(.leading, 10)
                        HStack(spacing: 20) {
                            Text("Photos").background(Rectangle().fill(.white))
                                .frame(width: UIScreen.main.bounds.width/4, height: 50)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(25)
                            Button {
                                showVideos.toggle()
                            } label: {
                                Text("Videos")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width/4, height: 50)
                                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .cornerRadius(25)
                            }
                            .fullScreenCover(isPresented: $showVideos) {
                                VideosLibraryView(selectedVideos: $selectedVideos)
                            }
                            Spacer()
                            Button {
                                print("btn tapped")
                            } label: {
                                Image(systemName: "photo")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width/6, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(.gray, lineWidth: 2)
                                    )
                            }
                            
                        }}) {
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: sectionZeroRows, spacing: 5) {
                                    ForEach(selectedPhotos, id: \.self) { index in
                    SectionZeroCell(showingModal: $showingModal, selectedCellImage: $selectedCellImage, cellImage: img,  photo: index)
                                    }
                                }
                                .frame(height: 250)
                            }
                            .scrollIndicators(.hidden)
                        }
                    //MARK: - Section One -
                    Section(header:   HStack{
                        Text("Couple photos")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            showSeeAllSectionOneView.toggle()
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                        )}
                        .fullScreenCover(isPresented: $showSeeAllSectionOneView) {
                SeeAllView(selectedData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}))
                        }
                    }){
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 8) {
                                ForEach($coupleData, id: \.id) { index in
                                    SectionOneCell(showDetailsView: $showDetailsView, imageData: index, selectedCellData: $selectededCoupleData)
                                }
.flipsForRightToLeftLayoutDirection(true)
.environment(\.layoutDirection, .rightToLeft)
                            }
                        }
                    }
                    
                    //MARK: - Section Three -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Discover new styles")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "paintpalette.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Button {
                            showSeeAllSectionThreeView.toggle()
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )
                        }
                        .fullScreenCover(isPresented: $showSeeAllSectionThreeView) {
                            AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
                        }
                        
                    }) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                ForEach(selfieData, id: \.id) { index in
                                    SectionThreeCell(showAIPhotosView: $showAIPhotosView, imageData: index)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    //MARK: - Section Four -
                    // NavigationView {
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Yellow Toon")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "sun.max"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        Spacer()
                        Button {
                            showYellowToon.toggle()
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                        )}
                        .fullScreenCover(isPresented: $showYellowToon) {
                            YellowToonView(selectedImages: selectedImages)
                        }
                        
                    }) {
                        LazyHGrid(rows: rows) {
                            ForEach(0..<1) { index in
                                SectionFourCell(showYellowToolView: $showYellowToolView)
                            }
                        }
                    }
                    //MARK: - Section Five -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("AI hair salon")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "poweroutlet.type.l.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button {
                            print("btn tapped")
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )}
                        
                    }) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                ForEach(selfieData, id: \.id) { index in
                                    SectionFiveCell(imageData: index)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    //MARK: - Section Six -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Century of Fashion")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "tshirt.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button {
                            print("btn tapped")
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )}
                        
                    }) {
                        LazyHGrid(rows: rows) {
                            SectionSixCell(showVideoDetailsView: $showVideoDetailsView, selectedVideo: $selectedVideo,player: video)
                        }
                        .frame(height: 200)
                    }
                    
                    //MARK: - Section Seven -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Fresh new look")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "gift.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button {
                            print("btn tapped")
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )}
                        
                    }) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                ForEach(selfieData, id: \.id) { index in
                                SectionSevenCell(imageData: index)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    //MARK: - Section Eight -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Old money")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "teddybear.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.brown)
                        }
                        Spacer()
                        Button {
                            print("btn tapped")
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )}
                        
                    }) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                ForEach(oldImgData, id: \.self) { index in
                                    SectionEightCell(showAIPhotosView: $showAIPhotosViewTwo, imageData: index)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    //MARK: - Section Nine -
                    Section(header:  HStack{
                        HStack(alignment: .center, spacing: 20) {
                            Text("Curriculum headshot")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white) + Text(
                                    Image(systemName: "briefcase.fill"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.brown)
                        }
                        Spacer()
                        Button {
                            print("btn tapped")
                        } label: {
                            Text("See All")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width/4, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.gray, lineWidth: 2)
                                )}
                        
                    }) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                ForEach(selfieData, id: \.self) { index in
                                    SectionNineCell(imageData: index)
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(.black)
    }
}

struct ChooseYourGenderBottomSheetView: View {
    let databaseManager = DatabaseManager.shared
    let dismissBottomSheet: () -> Void
    @AppStorage("hasSelectedGender") var hasSelectedGender: Bool = false
    @AppStorage("selectGender") var selectedGender: String = ""
    func saveGenderToDatabase(gender: String) {
        databaseManager.saveGender(gender)
        hasSelectedGender = true
        selectedGender = gender
    }

    var body: some View {
            VStack {
                HStack {
                    Button {
                        dismissBottomSheet()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }.padding()
                    .padding(.trailing, 300)
                VStack(alignment: .center, spacing: 20) {
                    Image(systemName: "personalhotspot")
                        .font(.system(size: UIScreen.main.bounds.width/4))
                    Text("What's your gender?")
                        .font(.title.bold())
                    Text("We will only use this information to personalize your experience.")
                    Button {
                        selectedGender = "Female"
                        saveGenderToDatabase(gender: selectedGender)
                    } label: {
                        Text("Female")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                    )
                    
                    Button {
                        selectedGender = "Male"
                        saveGenderToDatabase(gender: selectedGender)
                    } label: {
                        Text("Male")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                    )
                    
                    Button {
                        selectedGender = "Other"
                        saveGenderToDatabase(gender: selectedGender)
                    } label: {
                        Text("Other")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
            )}
        }
    }
}

struct BottomTabHomePageView: View {
    @State var selectedImages: [UIImage]
    let rows = [GridItem(.flexible())]
    var body: some View {
        VStack {
            LazyHGrid(rows: rows, alignment: .bottom, spacing: 20) {
                ForEach(0..<3) { index in
                    BottomTabHomePageCells(selectedImages: selectedImages)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/6)
    }
}

struct BottomTabHomePageCells: View {
    @State var selectedImages: [UIImage]
    @State var showNewExploreView = false
    @State var showNewAIPhotosView = false
    @State var showImagePickerView = false
    @State var showNewAIFiltersView = false
    @State var selectedImage: UIImage? = nil
    var body: some View {
        HStack(alignment: .center, spacing: UIScreen.main.bounds.width/10) {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    print("btn tapped")
                    showImagePickerView.toggle()
                } label: {
                    Image(systemName: "sparkles")
                        .font(.system(size: 30))
                        .frame(width: UIScreen.main.bounds.width/6, height: 60)
                        .foregroundColor(.white)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .cornerRadius(10)
                    
                }
                .fullScreenCover(isPresented: $showImagePickerView) {
                    EnhanceImagePicker(selectedImage: $selectedImage)
                }
                Text("Enhance")
                    .scaledFont(name: "", size: 15)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    print("btn tapped")
                    showNewAIPhotosView.toggle()
                } label: {
                    Image(systemName: "camera.aperture")
                        .font(.system(size: 30))
                        .frame(width: UIScreen.main.bounds.width/6, height: 60)
                        .foregroundColor(.white)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showNewAIPhotosView) {
                    AIPhotosLoadingView(selectedImages: [Image(systemName: "")], selectedCount: Int(), selectedImagesTwo: selectedImages)
                }
                Text("AI Photos")
                    .scaledFont(name: "", size: 15)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    print("btn tapped")
                    showNewAIFiltersView.toggle()
                } label: {
                    Image(systemName: "dot.viewfinder")
                        .font(.system(size: 30))
                        .frame(width: UIScreen.main.bounds.width/6, height: 60)
                        .foregroundColor(.white)
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showNewAIFiltersView) {
                    AIFiltersLoadingView( selectedImage: selectedImages)
                }
                Text("AI Filters")
                    .scaledFont(name: "", size: 15)
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    print("btn tapped")
                    showNewExploreView.toggle()
                } label: {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 30))
                        .frame(width: UIScreen.main.bounds.width/6, height: 60)
                        .foregroundColor(.white)
                        .background(Color(red: 2.4, green: 0.6, blue: 0.2))
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showNewExploreView) {
                    ExploreView(selectedImg: Image(systemName: ""), selectedImage: selectedImages)
                }
                Text("Explore")
                    .scaledFont(name: "", size: 15)
                    .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/6)
        .background(.black)
    }
}

struct EnhanceImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        init(selectedImage: Binding<UIImage?>) {
            self._selectedImage = selectedImage
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            selectedImage = image
            picker.dismiss(animated: true)
        }
    }
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }
    
    func makeUIViewController(context: Context) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

struct SectionZeroCell: View {
    @Binding var showingModal: Bool
    @Binding var selectedCellImage: UIImage
    @State var cellImage: UIImage? = nil
    var photo: PHAsset
    func fetchImage() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = false
        manager.requestImage(for: photo, targetSize: CGSize(width: UIScreen.main.bounds.width/3.1, height: 120), contentMode: .aspectFill, options: option) { result, _ in
            if let result = result {
                self.cellImage = result
            }
      }
}
    var body: some View {
        VStack {
            ZStack {
                if let image = cellImage {
                    Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width/3.1, height: 120)
                    .background(.red)
                    .cornerRadius(10)
                    .onTapGesture {
                    showingModal = true
                    selectedCellImage = image
                }
            }
        }
                .onAppear() {
                    fetchImage()
            }
        }
    }
}

struct SectionOneCell: View {
    @Binding var showDetailsView: Bool
    @Binding var imageData: CoupleDataModel
    @Binding var selectedCellData: CoupleDataModel
    var body: some View {
        ZStack {
            Image(imageData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/3.3, height: 170)
                .cornerRadius(30)
            Text(imageData.text1)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.all, 5)
        }
        .onTapGesture {
            selectedCellData = imageData
            showDetailsView = true
        }
    }
}

struct SectionThreeCell: View {
    @Binding var showAIPhotosView: Bool
    let imageData: SelfieDataModel
    var body: some View {
        VStack {
            Image(imageData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/3.3, height: 150)
                .background(.red)
                .cornerRadius(30)
        }
        .onTapGesture {
            showAIPhotosView = true
        }
    }
}

struct SectionFourCell: View {
    @Binding var showYellowToolView: Bool
    var body: some View {
        ZStack {
            Image("img2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .background(.red)
                .cornerRadius(10)
            HStack(spacing: 40) {
                Text("hi")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20))
                    .tint(.white)
            }
            .padding(.top, 150)
        }
        .onTapGesture {
            showYellowToolView = true
        }
    }
}

struct SectionFiveCell: View {
    let imageData: SelfieDataModel
    var body: some View {
        Image(imageData.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width/3.3, height: 170)
            .background(.red)
            .cornerRadius(30)
    }
}

struct SectionSixCell: View {
    @Binding var showVideoDetailsView: Bool
    @Binding var selectedVideo: AVPlayer
    let player: AVPlayer
    var body: some View {
        SectionSixAVPlayerControllerRepresented(player: player)
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: 200)
            .onTapGesture {
                selectedVideo = player
                showVideoDetailsView.toggle()
        }
    }
}

struct SectionSixAVPlayerControllerRepresented: UIViewControllerRepresentable {
    
    var player: AVPlayer
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        player.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct SectionSevenCell: View {
    let imageData: SelfieDataModel
    var body: some View {
        Image(imageData.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width/3.3, height: 170)
            .background(.red)
            .cornerRadius(30)
    }
}

struct SectionEightCell: View {
    @Binding var showAIPhotosView: Bool
    let imageData: OldImagesDataModel
    var body: some View {
        VStack {
            Image(imageData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/3.3, height: 170)
                .background(.red)
                .cornerRadius(30)
        }
            .onTapGesture {
                showAIPhotosView = true
        }
    }
}

struct SectionNineCell: View {
    let imageData: SelfieDataModel
    var body: some View {
        Image(imageData.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width/3.3, height: 170)
            .background(.red)
            .cornerRadius(30)
    }
}

struct ModalView: View {
    @State var enhanceImage = false
    @State var selectedImage: UIImage
    @Binding var showingModal: Bool
    let dismissModal: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.vertical)
            VStack(spacing: 20) {
                ZStack {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 400, height: 450)
                    Button(action: {
                        dismissModal()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(.black.opacity(0.2))
                            .cornerRadius(25)
                    }
                    .padding(.leading, -130)
                }
                .frame(height: 20)
                Spacer()
                    .frame(height: 200)
                HStack {
                    VStack {
                        Button {
                            enhanceImage.toggle()
                        } label: {
                            HStack(spacing: 30) {
                                Text("Enhance")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .fullScreenCover(isPresented: $enhanceImage) {
                            EnhancedModalImage(image: $selectedImage)
                        }
                        .frame(width: UIScreen.main.bounds.width - 120, height: 70)
                        .background(.black)
                        .cornerRadius(35)
                        Button {
                            print("btn tapped")
                        } label: {
                            HStack(spacing: 40) {
                                Image("img3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(35)
                                Text("Retake shot\n random text")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 120, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(.gray.opacity(0.3), lineWidth: 2)
                        )}
                }
                .padding(.bottom, 10)
            }
            .frame(width: 300, height: 500)
            .background(Color.white)
            .cornerRadius(20).shadow(radius: 20)
        }
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

struct SeeAllView: View {
    @State var selectedData: CoupleDataModel
    @StateObject var imageDataArray = CoupleData()
    @State var showNewView = false
    @State var showDetailsView = false
    @Environment(\.presentationMode) var presentationMode
    let columns = [
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 30) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        showNewView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .background(Rectangle().fill(.white))
                            .frame(width: UIScreen.main.bounds.width/9, height: 40)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(20)
                    }
                    .fullScreenCover(isPresented: $showNewView) {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
                    }
                    Text("Couple photos").font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                }
                .padding(.leading, 20)
                VStack {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(imageDataArray.coupleData, id: \.id) { index in
                                SeeAllCellView(imageData: index, isSelected: $selectedData)
                                    .onTapGesture {
                                        selectedData = index
                                        showDetailsView.toggle()
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.top)
                
                .fullScreenCover(isPresented: $showDetailsView) {
                    DetailsView(showPickForTwo: Bool(), selected1: PHAsset(),selected2: PHAsset(),selectedImages: [Image(systemName: "")], selectedImage: UIImage(), image: UIImage(), selection1: $selectedData)
                }
            }
            .padding(.bottom)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}

struct SeeAllView_Previews: PreviewProvider {
    static var previews: some View {
        SeeAllView(selectedData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}))
    }
}

struct SeeAllCellView: View{
    var imageData: CoupleDataModel
    @Binding var isSelected: CoupleDataModel
    var body: some View {
        VStack {
            Image(imageData.image)
                .resizable()
                .aspectRatio(CGSize(width: UIScreen.main.bounds.width/1.1, height: 150),contentMode: .fill)
            VStack(spacing: 5) {
                HStack {
                    Text(imageData.text1)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.leading, -160)
                HStack(spacing: 70) {
                    VStack (alignment: .trailing){
                        Text(imageData.text2)
                            .background(Rectangle().fill(.gray))
                            .frame(width: UIScreen.main.bounds.width/3.0, height: 40)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    Button {
                        print("")
                    } label: {
                        Text("Get This Pack")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width/3, height: 50)
                            .background(.white)
                            .cornerRadius(30)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.1, height: 100)
            .background(.black).ignoresSafeArea()
        }
        .frame(width: UIScreen.main.bounds.width/1.1, height: 300)
        .background(.black)
        .cornerRadius(20)
    }
}

struct DetailsView: View {
    @State var showPickForTwo = false
    @State var selected1: PHAsset
    @State var selected2: PHAsset
    @State var selectedImages: [Image]
    @State var selectedImage: UIImage
    @State var image: UIImage
    @Binding var selection1: CoupleDataModel
    var body: some View {
        NavigationStack {
            VStack {
                if let selection = selection1 {
                    Image(selection.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2).ignoresSafeArea()
                    Spacer()
                    VStack(alignment: .center, spacing: 20) {
                        VStack(spacing: 30) {
                            Text(selection.text1)
                                .background(Rectangle().fill(.gray))
                                .frame(width: UIScreen.main.bounds.width/3.2, height: 40)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .background(.gray)
                                .cornerRadius(10)
                            Text(selection.text2)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, -120)
                        Text("Create beautiful wedding pictures of you\n and your better half")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white)
NavigationLink(destination: PickForTwoView(selectedImages: [Image(systemName: "")], selectedImage: UIImage(), selectedImage1:UIImage() ,selectedImage2: UIImage(),selectedImagesForLazyVGrid: [UIImage](), image: image, images: [PHAsset]()), isActive: $showPickForTwo) {
                            Button {
                                showPickForTwo.toggle()
                            } label: {
                                HStack(spacing: 30) {
                                    Text("Pick Two People")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                                .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                                .background(.white)
                                .cornerRadius(30)
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitle("")
                    }
                }
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        }
        .accentColor(.white)
    }
}

struct PickForTwoView: View {
    @State var selectedImages: [Image]
    @State var selectedImage: UIImage?
    @State var showImagePickerView = false
    @State var showSelectGenderView = false
    @State var showNextScreen = false
    @State var selectedImage1: UIImage?
    @State var selectedImage2: UIImage?
    @State var selectedImagesForLazyVGrid: [UIImage]
    @State var image: UIImage
    @State var showContinueButton = false
    @State var images: [PHAsset] = []
    let textPerson1 = "Person 1"
    let textPerson2 = "Person 2"
    let sectionZeroRows = [
        GridItem(.flexible(), spacing: -80, alignment: .center),
        GridItem(.flexible(), spacing: -80, alignment: .center),
        GridItem(.flexible(), spacing: -80, alignment: .center)
    ]
    func fetchPhotos() {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                    assets.enumerateObjects { (object,_, _) in
                        self.images.append(object)
                    }
                } else if status == .denied {
                    
                }
            }
        }
    }
    var body: some View {
            VStack {
                VStack {
                    HStack {
                        Text("Pick 2 People")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                VStack {
                    ScrollView(.vertical) {
                        Section(header: HStack(spacing: 100) {
                            Text("Your photos")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Button {
                                showImagePickerView.toggle()
                            } label: {
                                Text("Open Gallery")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width/3, height: 50)
                                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .cornerRadius(25)
                            }
                            .fullScreenCover(isPresented: $showImagePickerView) {
                                PickForTwoImagePicker(selectedImage: $selectedImagesForLazyVGrid, selectedImages: $selectedImages, showNextScreen: $showNextScreen)
                            }
                        }
                        ) {
                            LazyVGrid(columns: sectionZeroRows, spacing: 5) {
                                ForEach(images, id: \.self) { index in
                                    PickForTwoViewCell(cellImage: image, onTap: { photo in
                                        handleImageSelection(photo)
                                        images.append(index)
                                    }, photo: index)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                HStack(spacing: 20) {
                    Button {
                        print("")
                    } label: {
                        VStack {
                            if let image = selectedImage1 {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                Text(textPerson1)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top)
                    }
                    
                    Button {
                        print("")
                    } label: {
                        VStack {
                            if let image = selectedImage2 {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                Text(textPerson2)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.leading, -160)
                if showContinueButton {
                    NavigationLink(destination: FirstSelectGenderView(selectedImage1: $selectedImage1, selectedImage2: $selectedImage2, textPerson1: textPerson1, textPerson2: textPerson2), isActive: $showSelectGenderView) {
                        Button {
                            showSelectGenderView.toggle()
                        } label: {
                            Text("Continue")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: UIScreen.main.bounds.width/1.5, height: 50)
                                .background(.white)
                                .cornerRadius(25)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("")
                }
            }
            .padding(.bottom, 50)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.1)
            .background(Color.black.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.async {
                fetchPhotos()
            }
        }
    }

    func handleImageSelection(_ image: UIImage) {
        DispatchQueue.main.async {
            if self.selectedImages.count == 1 {
                    self.selectedImage1 = image
                    self.selectedImages.append(Image(uiImage: image))
            } else if self.selectedImages.count == 2 {
                    self.selectedImage2 = image
                    self.selectedImages.append(Image(uiImage: image))
                    self.showContinueButton = true
            }
        }
    }
}
struct PickForTwoViewCell: View {
    @State var cellImage: UIImage
    var onTap: (UIImage) -> Void
    var photo: PHAsset
    func fetchImage() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        manager.requestImage(for: photo, targetSize: CGSize(width: UIScreen.main.bounds.width/4.5, height: 120), contentMode: .aspectFill, options: option) { result, _ in
            DispatchQueue.main.async {
                if let result = result {
                    self.cellImage = result
                }
            }
        }
    }
    var body: some View {
        VStack {
            ZStack {
                if let image = cellImage {
                    Image(uiImage: image)
                        .frame(width: UIScreen.main.bounds.width/4.5, height: 80)
                        .cornerRadius(10)
                        .onTapGesture {
                            onTap(image)
                    }
                }
            }
            .onAppear() {
                fetchImage()
            }
        }
    }
}

struct FirstSelectGenderView: View {
    @Binding var selectedImage1: UIImage?
    @Binding var selectedImage2: UIImage?
    @State var selectedGender: String? = nil
    @State var isNextButtonEnabled = false
    @State var showNextView = false
    var textPerson1: String
    var textPerson2: String
    var body: some View {
            VStack {
                HStack(spacing: 20) {
                    VStack {
                        if let image1 = selectedImage1 {
                            Image(uiImage: image1)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(25)
                        }
                        Text(textPerson1)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    VStack {
                        if let image2 = selectedImage2 {
                            Image(uiImage: image2)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(25)
                                .disabled(true)
                        }
                        Text(textPerson2)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .hidden()
                    }
                }
                .padding(.leading, 50)
                Spacer()
                    .frame(height: 100)
                VStack(spacing: 20) {
                    Text("Gender")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Button {
                        selectedGender = "Female"
                        isNextButtonEnabled = true
                    } label: {
                        Text("Female")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(selectedGender == "Female" ? .white : .gray.opacity(0.3), lineWidth: 2))
                    
                    Button {
                        selectedGender = "Male"
                        isNextButtonEnabled = true
                    } label: {
                        Text("Male")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(selectedGender == "Male" ? .white : .gray.opacity(0.3), lineWidth: 2))
                    NavigationLink(destination: SecondSelectGenderView(selectedImage1: $selectedImage1, selectedImage2: $selectedImage2, textPerson1: textPerson1, textPerson2: textPerson2), isActive: $showNextView) {
                        Button {
                            selectedGender = "Other"
                            isNextButtonEnabled = true
                        } label: {
                            Text("Other")
                                .font(.system(size: 16,weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(selectedGender == "Other" ? .white : .gray.opacity(0.3), lineWidth: 2))
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("")
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .background(.secondary)
                .cornerRadius(20)
                Spacer()
                    .frame(height: 80)
                VStack {
                    HStack(spacing: 30) {
                        Button {
                            showNextView.toggle()
                        } label: {
                            HStack(spacing: 30) {
                                Text("Next")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                        .disabled(!isNextButtonEnabled)
                        .background(isNextButtonEnabled ? Color.white : Color.gray)
                        .cornerRadius(30)
                    }
                    .padding(.bottom, 50)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.black.ignoresSafeArea())
    }
}

struct SecondSelectGenderView: View {
    @Binding var selectedImage1: UIImage?
    @Binding var selectedImage2: UIImage?
    @State var selectedGender: String? = nil
    @State var isNextButtonEnabled = false
    @State var showNextView = false
    @State var showTermsAndConditions = false
    @State var showLoadingView = false
    var textPerson1: String
    var textPerson2: String
    var body: some View {
            VStack {
                HStack(spacing: 20) {
                    VStack {
                        if let image1 = selectedImage1 {
                            Image(uiImage: image1)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(25)
                                .disabled(true)
                            
                        }
                        Text(textPerson1)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .hidden()
                    }
                    VStack {
                        if let image2 = selectedImage2 {
                            Image(uiImage: image2)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(25)
                        }
                        Text(textPerson2)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 50)
                Spacer()
                    .frame(height: 70)
                VStack(spacing: 20) {
                    Text("Gender")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Button {
                        selectedGender = "Female"
                        isNextButtonEnabled = true
                        showTermsAndConditions = true
                    } label: {
                        Text("Female")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(selectedGender == "Female" ? .white : .gray.opacity(0.3), lineWidth: 2))
                    
                    Button {
                        selectedGender = "Male"
                        isNextButtonEnabled = true
                        showTermsAndConditions = true
                    } label: {
                        Text("Male")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(selectedGender == "Male" ? .white : .gray.opacity(0.3), lineWidth: 2))
                    Button {
                        selectedGender = "Other"
                        isNextButtonEnabled = true
                        showTermsAndConditions = true
                    } label: {
                        Text("Other")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(selectedGender == "Other" ? .white : .gray.opacity(0.3), lineWidth: 2))
                }
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .background(.secondary)
                .cornerRadius(20)
                Spacer()
                    .frame(height: 20)
                HStack {
                    Text("By tapping Start Generation, declare that you have all necessary\n right and permissions to share these images and information with us\n and that you will use the images generated lawfully\n\n If you upload images that include minors, by tapping Start\n Generation, declare that you have parental responsibility for them\n and the necessary rights to share the images.")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.white)
                        .opacity(showTermsAndConditions ? 1 : 0)
                }
                VStack {
                    Spacer()
                        .frame(height: 20)
                    VStack(spacing: 30) {
                        Button {
                            showLoadingView = true
                        } label: {
                            HStack(spacing: 30) {
                                Text("Start Generation")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                        .disabled(!isNextButtonEnabled)
                        .background(isNextButtonEnabled ? Color.white : Color.gray)
                        .cornerRadius(30)
                    }
                    .fullScreenCover(isPresented: $showLoadingView) {
                        GenderSelectionLoadingView(selectedImage1: $selectedImage1, selectedImage2: $selectedImage2,isActive: true)
                    }
                    .padding(.bottom, 50)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.black.ignoresSafeArea())
    }
}

struct GenderSelectionLoadingView: View {
    @Binding var selectedImage1: UIImage?
    @Binding var selectedImage2: UIImage?
    @State var selectedImages: [UIImage] = []
    @State var isPresentedView = false
    @State var isActive: Bool
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    var body: some View {
            VStack {
                HStack(alignment: .center, spacing: 20) {
                    Text("Loading...")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
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
                FilteredPickForTwoView(selectedImage1: $selectedImage1, selectedImage2: $selectedImage2)
            }
            .background(.black.opacity(0.2))
            .ignoresSafeArea()
    }
}

struct PickForTwoImagePicker: UIViewControllerRepresentable {
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
            self?.selectedImages.append(Image(uiImage: image))
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

struct UIKitNavigationController: UIViewControllerRepresentable {
    let navVC: UINavigationController
    
    init(rootViewController: UIViewController) {
        navVC = UINavigationController(rootViewController: rootViewController)
    }
    func makeUIViewController(context: Context) -> UINavigationController {
        return navVC
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}


