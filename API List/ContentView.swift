//
//  ContentView.swift
//  API List
//
//  Created by Jack Kamaryt on 2/21/23.
//

import SwiftUI

struct ContentView: View {
    @State private var categories = [String]()
    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                NavigationLink(destination: Text(category)){ //automatically creates new view with text in it - in this case (category)
                    Text(category)
                }
                
            }
            .navigationTitle("API Categories")
        }
        .task {
            await getCategories()
        }
    }
    
    func getCategories() async {
            let query = "https://api.publicapis.org/categories"
            if let url = URL(string: query) {
                if let (data, _) = try? await URLSession.shared.data(from: url) {
                    if let decodedResponse = try? JSONDecoder().decode(Categories.self, from: data) {
                        categories = decodedResponse.categories
                    }
                }
            }
        }
    // The query string is the web address, which is then converted into a URL object. Next, the actual background download occurs in a URLSession received as JSON data. Finally, the JSON data is decoded using a JSONDecoder using the Categories struct and the decoded data is placed in the categories array.
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Categories: Codable {
var categories: [String]
}
