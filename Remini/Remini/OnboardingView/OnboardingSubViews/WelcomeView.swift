//
//  WelcomeView.swift
//  Remini_
//
//  Created by Mac on 22/05/2024.
//

import SwiftUI
import AVKit

struct WelcomeView: View {
    @StateObject var appImageModel = Data()
    @State var show = false
    var body: some View {
        Color.black.ignoresSafeArea()
            .overlay(
                    VStack {
                        WelcomeLazyVGridView(appImageData: appImageModel.imageData, image: Image(""))
            }
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(appImageModel: Data())
    }
}

struct WelcomeLazyVGridView: View {
    var appImageData: [AppDataModel]
    @State var header = true
    @State var showContinueButton = false
    @State var cellsEnabled = true
    @State var showNextView = false
    let image: Image
    let columns = [
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            VStack {
                Section(header: VStack { HStack {
                    VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Welcome to Remini!")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray).opacity(header ? 1.0 : 0.0)
                                    .offset(y: header ? 0 : -30)
                                    .animation(.easeInOut, value: header)
                            }
                        HStack {
                            Text("What brings you here?")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                showNextView.toggle()
                            }) {
                                Text("Skip")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)

                            }
                            .fullScreenCover(isPresented: $showNextView){
                                AcceptAndContinueView()
                            }
                            .frame(width: 80, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.gray, lineWidth: 2)
                            )
                            .offset(y: -10)
                        }
                        .frame(height: header ? 40 : 10)
                    }
                    
                }}) {
                    ZStack{
                        ScrollViewReader { g in
                        ScrollView {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                                ForEach(appImageData, id: \.id) { index in
                WelcomeCellView(showContinueButton: $showContinueButton, cellsEnabled: $cellsEnabled, imageData: index)
                                }
                                .opacity(cellsEnabled ? 1 : 0.5)
                                .allowsHitTesting(cellsEnabled)
                            }
                            .animation(.easeInOut, value: header)
                            .background(GeometryReader { geometryProxy -> Color in
                                DispatchQueue.main.async {
                                    header = geometryProxy.frame(in: .named("1")).minY >= 0
                                }
                               return Color.clear
                            })
                        }
                    }
                    .coordinateSpace(name: "1")
                    .offset(y: header ? 40 : 20)
                }
            }
        }
        
            .scrollIndicators(.hidden)
            .padding(.vertical, 10)
            if showContinueButton {
                Button(action: {
                    showNextView.toggle()
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }.fullScreenCover(isPresented: $showNextView, content: {
                    AcceptAndContinueView()
                })
                .padding(.bottom, 20)
                .frame(width: UIScreen.main.bounds.width - 50, height: 60, alignment: .bottom)
                .background(.white)
                .cornerRadius(30)
            }
        }
        .padding(.bottom, 40)
        .onChange(of: showContinueButton, perform: { newValue in
            if newValue {
                cellsEnabled = false
            } else {
                cellsEnabled = true
            }
        })
        .padding(.top)
    }
}

struct WelcomeCellView: View {
    @Binding var showContinueButton: Bool
    @Binding var cellsEnabled: Bool
    @State var isTapped: Bool = false
    var imageData: AppDataModel
    let screenSize = UIScreen.main.bounds.size
    var body: some View {
        HStack(spacing: 20) {
            Image(imageData.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)       .frame(width: 90, height: 90)
                    .cornerRadius(45)
            VStack(alignment: .leading, spacing: 10) {
                Text(imageData.text1)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                Text(imageData.text2)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            Spacer()
            Button(action: {
                showContinueButton = true
                isTapped.toggle()
            }) {
                Image(systemName: isTapped ? imageData.buttonImage2 : imageData.buttonImage1)
                    .font(.system(size: 40))
                    .foregroundColor(isTapped ? .white : .gray)
            }
            .disabled(!cellsEnabled)
            .offset(x: -20)
        }
        .frame(width: screenSize.width, height: UIScreen.main.bounds.height/8)
        .background(.secondary)
        .cornerRadius(30)
    }
}
     
struct AcceptAndContinueView: View {
    @State var showNextView = false
    var body: some View {
        Color(red: 0.1, green: 0.1, blue: 0.1)
            .ignoresSafeArea(.all)
            .overlay(
                VStack {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 20) {
                            Image(systemName: "lock.icloud.fill")
                                .font(.system(size: UIScreen.main.bounds.width/2.5))
                                .foregroundColor(Color(red: 0.98, green: 0.70, blue: 0.9))
                                .padding(.horizontal, 70)
                            Text("We value your privacy.")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("""
We use tracking technologies that either are essential
for the app to function correctly or are used to
produce aggregated statistics. With your consent, we
and our third-party partners will also use tracking technologies to improve the in-app experience, and
to provide you with personalized services and
targeted advertising. To give consent, tap
Accept All and Continue.\n\n
Alternatively, you can customize your privacy settings
by tapping Customize Preferences, or by going to
Privacy Settings at any time. If you don't want us to
use non-technical tracking technologies, tap Refuse.\n\n
For more information about how we process your
personal data through tracking technologies, take a
look at our [Privacy Policy](link1).
""")
                            .scaledFont(name: "", size: 16)
                            .foregroundColor(.white)
                            .tint(.red)
                            .multilineTextAlignment(.leading)
                        }
                        .padding(.top, 100)
                    }
                    .scrollIndicators(.hidden)
                }
            )
        VStack {
                VStack(spacing: 20) {
                    Button(action: {
                        showNextView.toggle()
                    }) {
                        Text("Accept All and Continue")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                    }.fullScreenCover(isPresented: $showNextView) {
                        WelcomeToReminiView()
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60, alignment: .bottom)
                    .background(.white)
                    .cornerRadius(30)
                    Button(action: {
                    }) {
                        Text("Refuse")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, height: 60)
                    .background(.white)
                    .cornerRadius(30)
                    Button(action: {
                    }) {
                        Text("Customize Preferences")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .underline(color: .white)
                    }
                }
            }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5)
        .background(.black).ignoresSafeArea()
        }
    }

struct WelcomeToReminiView: View {
    @State var showNextView = false
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 20){
                HStack {
                    Image(systemName: "person.icloud")
                        .font(.system(size: UIScreen.main.bounds.width/2.0))
                        .foregroundColor(.yellow)
                        .padding(.leading, 170)
                        .padding(.top, -80)
                }
                Text("Welcome to\n Remini!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                Text("To provide our services, we process information\n about the faces in your photos and videos. By \n tapping Continue you consent to the collection\n and use of such data, which may be considered \n biometric data, for the purposes of enhancing \n your photos and videos and generating images. \n\n\n If you don't want to provide us with this data, it's \n not possible to enjoy the app's functionalities. To \n learn more about how we process your data, \n please see our [Privacy Policy]. \n\n\n If you upload images that include minors, you, as \n the holder of parental responsibility, also consent \n to the collection and use of the minors' Face Data.")
                    .scaledFont(name: "", size: 16)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
        }
        VStack {
            Button(action: {
                showNextView.toggle()
            }) {
                HStack(spacing: 30) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .padding(.trailing, -40)
                        .foregroundColor(.white)
                }
            }.fullScreenCover(isPresented: $showNextView, content: {
                OnboardingLoadingView()
            })
            .frame(width: UIScreen.main.bounds.width - 100, height: 60)
            .background(.black)
            .cornerRadius(30)
        }
        .padding(.top, 10)
        .padding(.bottom, 90)
        .frame(maxWidth: .infinity, idealHeight: UIScreen.main.bounds.height)
        .background(Color(.white)
            .ignoresSafeArea())
        .offset(y: 2)
    }
}

struct OnboardingLoadingView: View {
    @State var playVideo = false
    @State var isPresentedWelcomeView = false
    @State var rotatingAngle: Double = 0.0
    @State var trimAmount: Double = 0.1
    @State var onboardingState = false
    var player: AVPlayer {
        AVPlayer(url: Bundle.main.url(forResource: "onboardingImg", withExtension: "mp4")!)
    }
    var body: some View {
        Color.white.ignoresSafeArea(.all)
            .overlay(
                VStack(spacing: 30) {
                    LoadingOnboardingAVPlayerControllerRepresented(player: player)
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
                                .onAppear{
                                    self.rotatingAngle = 360.0
                                    self.trimAmount = 1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            onboardingState  = true
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 100, height: 60)
                    .background(.black.opacity(0.3))
                    .cornerRadius(30)
                    }
                    .fullScreenCover(isPresented: $isPresentedWelcomeView) {
                        FirstImageView()
                    }
                    .padding()
                    .offset(y: -80)
        )
    }
}

struct LoadingOnboardingAVPlayerControllerRepresented: UIViewControllerRepresentable {
    
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
