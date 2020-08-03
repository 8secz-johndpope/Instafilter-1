//
//  ContentView.swift
//  Instafilter
//
//  Created by Nate Lee on 7/28/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var inputUIImage: UIImage?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.secondary)
                
                // Display the image
                if image != nil {
                    image!
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
            }
            .onTapGesture {
                // Select an image picker
                self.showingImagePicker = true
            }
            
            HStack {
                Text("Intensity")
                
                Slider(value: $filterIntensity)
            }
            .padding(.vertical)
            
            HStack {
                Button("Change Filter") {
                    // TODO: - Change Filter
                }
                
                Spacer()
                
                Button("Save") {
                    // TODO: - Save the photo applied with the filter
                }
            }
            
        }
        .padding([.bottom, .horizontal])
        .navigationBarTitle("Instafilter")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(inputUIImage: self.$inputUIImage)
        }
    }
    
    // Custom Funcs go here...
    func loadImage() {
        guard let inputUIImage = inputUIImage else { return }
        self.image = Image(uiImage: inputUIImage)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
