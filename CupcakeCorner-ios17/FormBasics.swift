//
//  FormBasics.swift
//  CupcakeCorner-ios17
//
//  Created by Alin RADU on 07.02.2024.
//

import SwiftUI

struct FormBasics: View {
    @State private var username = ""
    @State private var email = ""

    var disableForm: Bool {
        username.count < 5 && email.count < 5
    }

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }

            Section {
                Button("Create Account") {
                    print("creating account...")
                }
            }
            .disabled(username.isEmpty || email.isEmpty)
        }
    }
}

#Preview {
    FormBasics()
}
