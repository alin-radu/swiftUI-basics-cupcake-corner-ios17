//
//  AsyncImageBasics.swift
//  CupcakeCorner-ios17
//
//  Created by Alin RADU on 07.02.2024.
//

import SwiftUI

struct AsyncImageBasics: View {
    private let BASE_URL = "https://hws.dev/img/logo.png"

    var body: some View {
        // AsyncImage(url: URL(string: BASE_URL), scale: 3)

        // AsyncImage(url: URL(string: BASE_URL)) { image in
        //     image
        //         .resizable()
        //         .scaledToFit()
        // } placeholder: {
        //     ProgressView()
        // }
        // .frame(width: 200, height: 200)

        AsyncImage(url: URL(string: BASE_URL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    AsyncImageBasics()
}
