//
//  ContentView.swift
//  Remini_
//
//  Created by Mac on 21/05/2024.
//

import SwiftUI
import AVKit

struct OnboardingView: View {
    @AppStorage("onboardingScreenShown") var onboardingScreenShown: Bool = false
    @State var playVideo = false
    @State var isPresentedWelcomeView = false
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    var player: AVPlayer {
        AVPlayer(url: Bundle.main.url(forResource: "onboardingImg", withExtension: "mp4")!)
    }
    var body: some View {
        Color.white.ignoresSafeArea(.all)
            .overlay(
                VStack(spacing: 30) {
                    OnboardingAVPlayerControllerRepresented(player: player)
                        .aspectRatio(CGSize(width: UIScreen.main.bounds.width, height: 100.0), contentMode: .fill)
                        .ignoresSafeArea(.all)
                    Text("Take your photos\n to new heights")
                        .font(.system(size: 40, weight: .semibold))
                    
                    Button(action: {
                        isPresentedWelcomeView = true
                    })
                    {
                        HStack(spacing: 30) {
                            Text("Get Started")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing, -40)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                    .background(Color.black)
                    .cornerRadius(30)
                    }
                    .fullScreenCover(isPresented: $isPresentedWelcomeView) {
                        WelcomeView(appImageModel: Data())
                    }
                    .padding()
                    .offset(y: -80)
            )
            .onAppear() {
                UserDefaults.standard.onboardingScreenShown = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct OnboardingAVPlayerControllerRepresented: UIViewControllerRepresentable {
    
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

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
