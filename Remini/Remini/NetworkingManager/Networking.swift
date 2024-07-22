//
//  ImageData.swift
//  Remini_
//
//  Created by Mac on 07/06/2024.
//

import Foundation
import SQLite
import SQLite3
import UIKit
import SwiftUI
import CoreImage

class ImageManager {
    static let shared = ImageManager()
    
    func fetchImageUrls(completion: @escaping(ImageData) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "http://localhost:3002/images")!) { data, response, error in
            if let error = error {
                print(String(describing: error))
            } else  if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ImageData.self, from: data)
                    completion(decodedData)
                    print("\(decodedData.imgUrls)")
                } catch {
                    print(String(describing: error))
                }
            }
        }.resume()
    }
}

class DatabaseManager {
    static let shared = DatabaseManager()
    let db: Connection?
    //    let images = Table("images")
    //    let id = Expression<Int64>("id")
    //    let imageData = Expression<Data>("imageData")
    private init() {
        do {
            db = try
            Connection(.inMemory)
            createTableForUsers()
        } catch {
            db = nil
            print("Unable to connect to database: \(error)")
        }
    }
    func createTableForUsers() {
        let users = Table("users")
        let gender = Expression<String>("gender")
        do {
            try db!.run(users.create{ t in
                t.column(gender)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func saveGender(_ gender: String) {
        let users = Table("users")
        let genderColumn = Expression<String>("gender")
        do {
            try db?.run(users.insert(genderColumn <- gender))
        } catch {
            print("Unable to save gender: \(error)")
        }
    }
    
    func getUserGender() -> String? {
        let users = Table("users")
        let gender = Expression<String>("gender")
        do {
            if let user = try db?.pluck(users) {
                return try user.get(gender)
            } else {
                return nil
            }
        } catch {
            print("Unable to retrieve user gender\(error)")
            return nil
        }
    }
}

class AIService {
    static let shared = AIService()
    private init() {}
    //let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
   
    func enhanceCoupleImages() {}
    func generateImage() {
    }

    func enhanceOldImages() {}
}

