//
//  mylibraryApp.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftUI
import SwiftData

@main
struct MyLibrary: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
        .modelContainer(for: Book.self)
    }
}


