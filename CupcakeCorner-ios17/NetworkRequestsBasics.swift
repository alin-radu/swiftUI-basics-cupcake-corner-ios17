import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct NetworkRequestsBasics: View {
    @State private var results: [Result] = []

    private let BASE_URL = "https://itunes.apple.com/search?term=taylor+swift&entity=song"

    var body: some View {
        if results.isEmpty {
            Text("No data available")
                .font(.title3.bold())
                .task {
                    print("task --> start")
                    await loadData()
                }
        } else {
            List(results, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)

                    Text(item.collectionName)
                }
            }
        }
    }

    func loadData() async {
        print("loadData ---> start")

        // create the URL you want to read
        guard let url = URL(string: BASE_URL) else {
            print("Invalid URL")
            return
        }

        // fetching the data for that UR
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // convert the data to a string
            if let dataString = String(data: data, encoding: .utf8) {
                print("Data as string: \(dataString)")
            } else {
                print("Failed to convert response data to string")
            }
            

            // decoding the result of that data
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }

        print("loadData ---> end")
    }
}

#Preview {
    NetworkRequestsBasics()
}


