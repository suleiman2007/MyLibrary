//
//  mylibraryApp.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftUI
import SwiftData

@main
struct MyLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: Book.self)
    }
}


