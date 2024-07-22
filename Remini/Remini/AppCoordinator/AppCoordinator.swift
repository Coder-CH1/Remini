//
//  ViewCoordinator.swift
//  Remini_
//
//  Created by Mac on 21/05/2024.
//

import SwiftUI
import Photos

struct AppCoordinator: View {
    @State var isActive = false
    var body: some View {
        if !isActive {
            SplashView(isActive: $isActive)
        } else if UserDefaults.standard.onboardingScreenShown {
HomePageView(imageData: CoupleData(), selectedCellImage: UIImage(), selectedImages: [UIImage()], uiImage: UIImage(), images: [PHAsset](), videos: [PHAsset()], selectedImage: UIImage(), selectedCoupleData: CoupleDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedSelfieData: SelfieDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selectedOldImgData: OldImagesDataModel(image: "", text1: "", text2: "", buttonImage1: "", buttonImage2: "", buttonAction: {}), selected1: UIImage(), selected2: UIImage(), cellsImage: UIImage(), showVideoDetailsView: Bool(), selectedVideo: AVPlayer())
        } else {
            OnboardingView()
        }
    }
}

struct AppCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        AppCoordinator()
    }
}

extension UserDefaults {
    var onboardingScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "onboardingScreenShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "onboardingScreenShown")
        }
    }
}
