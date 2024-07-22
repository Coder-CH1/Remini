//
//  VideoTransformationView.swift
//  Remini_
//
//  Created by Mac on 16/07/2024.
//

import SwiftUI
import AVKit

struct VideoTransformationView: View {
    @Binding var selectedVideo: AVPlayer
    var body: some View {
        VStack {
            
        }
    }
}

struct VideoTransformationView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTransformationView(selectedVideo: .constant(AVPlayer()))
    }
}

