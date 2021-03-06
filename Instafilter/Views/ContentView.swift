//
//  ContentView.swift
//  Instafilter
//
//  Created by Nate Lee on 7/28/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
    let ciContext = CIContext() // Expensive to create!
    
    @State private var image: Image?
    @State private var inputUIImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    
    var body: some View {
        let intensityBinding = Binding<Double>(get: {
            self.filterIntensity
        }, set: { newValue in
            self.filterIntensity = newValue
            self.applyProcessing()
        })
        
        return VStack {
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
                
                Slider(value: intensityBinding)
            }
            .padding(.vertical)
            
            HStack {
                Button("Change Filter") {
                    // TODO: - Change Filter
                    self.showingFilterSheet = true
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
        .actionSheet(isPresented: $showingFilterSheet) {
            ActionSheet(
                title: Text("Filter List"),
                message: Text("Choose a filter"),
                buttons: [
                    .default(Text("Crystallize")) {
                        self.setFilter(CIFilter.crystallize())
                    },
                    .default(Text("Edges")) {
                        self.setFilter(CIFilter.edges())
                    },
                    .default(Text("Gaussian Blur")) {
                        self.setFilter(CIFilter.gaussianBlur())
                    },
                    .default(Text("Pixellate")) {
                        self.setFilter(CIFilter.pixellate())
                    },
                    .default(Text("Sepia Tone")) {
                        self.setFilter(CIFilter.sepiaTone())
                    },
                    .default(Text("Unsharp Mask")) {
                        self.setFilter(CIFilter.unsharpMask())
                    },
                    .default(Text("Vignette")) {
                        self.setFilter(CIFilter.vignette())
                    },
                    .cancel()
            ])
        }
    }
    
    // Custom Funcs go here...
    func setFilter(_ filter: CIFilter) {
        self.currentFilter = filter
        loadImage()
    }
    
    func loadImage() {
        guard let inputUIImage = inputUIImage else { return }
        
        // self.image = Image(uiImage: inputUIImage)
        let beginCIImage = CIImage(image: inputUIImage)
        currentFilter.setValue(beginCIImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        // currentFilter.intensity = Float(filterIntensity)
        // currentFilter.setValue(Float(filterIntensity), forKey: kCIInputIntensityKey) // This could crash!
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 180, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 9, forKey: kCIInputScaleKey)
        }
        
        guard
            let outputCIImage = currentFilter.outputImage,
            let outputCGImage = ciContext.createCGImage(outputCIImage, from: outputCIImage.extent)
            else { return }
        
        let outputUIImage = UIImage(cgImage: outputCGImage)
        image = Image(uiImage: outputUIImage)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
