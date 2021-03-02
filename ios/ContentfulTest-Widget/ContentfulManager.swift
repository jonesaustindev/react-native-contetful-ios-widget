//
//  ContentfulManager.swift
//  ContentfulTest-WidgetExtension
//
//  Created by Austin Jones on 3/2/21.
//

import Foundation
import Contentful

let client = Client(spaceId: "7fllrzkiugoh",
                    environmentId: "master", // Defaults to "master" if omitted.
                    accessToken: "MDJAfqqk33spGHOOtIQvBCARxeDyeRHQt2lV9t4AvRI")

let query = Query.where(contentTypeId: "iosWidget")

struct ContentfulManager {
  
  func fetchData(completionBlock: @escaping (String) -> Void) -> Void {
    client.fetchArray(of: Entry.self, matching: query) { (result: Result<HomogeneousArrayResponse<Entry>, Error>) in
        switch result {
        case .success(let entry):
          if let title = entry.items[0].fields["title"] {
            completionBlock(title as! String)
          }
        case .failure(let error):
          print("Error \(error)!")
        }
    }
  }
  
}
