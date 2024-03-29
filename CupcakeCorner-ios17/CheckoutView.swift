//
//  CheckoutView.swift
//  CupcakeCorner-ios17
//
//  Created by Alin RADU on 07.02.2024.
//

import SwiftUI

extension HTTPURLResponse {
    func printDetails() {
        print("----------------------")
        print("HTTP Response Details:")
        print("URL: \(url?.absoluteString ?? "N/A")")
        print("Status Code: \(statusCode)")
        print("Headers:")
        allHeaderFields.forEach { key, value in
            print("\t\(key): \(value)")
        }
    }
}

struct CheckoutView: View {
    var order: Order

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }

    func placeOrder() async {
        // convert our current order object into some JSON data that can be sent
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        // tell Swift how to send that data over a network call
        let url = URL(string: "https://reqres.in/api/cupcakes")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)

            // handle the result
            // convert the data to a string
            if let data = String(data: data, encoding: .utf8) {
                print("Response as string: \(data)")
            } else {
                print("Failed to convert response data to string")
            }

            // convert response to string
            if let httpResponse = response as? HTTPURLResponse {
                httpResponse.printDetails()
            } else {
                print("Failed to convert response to string")
            }

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true

        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}

// do {
//     let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//     // handle the result
// } catch {
//     print("Checkout failed: \(error.localizedDescription)")
// }


