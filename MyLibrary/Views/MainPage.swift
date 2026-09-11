//
//  MainPage.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftUI
import SwiftData
import UIKit

struct MainPage: View {
    
    @Query private var books: [Book]
    
    @State private var showAddBook = false
    @State private var selectedBook: Book?
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    
                    // MARK: - En-tête
                    HStack {
                        Text("MyLibrary")
                            .font(.system(size: 30))
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            showAddBook = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 25))
                                .foregroundStyle(.black)
                                .frame(width: 45, height: 45)
                        }
                    }
                    
                    // MARK: - Livres
                    VStack(spacing: 20) {
                        
                        // En train de lire
                        VStack(alignment: .leading) {
                            Text("En train de lire")
                                .font(.title2)
                                .bold()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.gray, lineWidth: 2)
                                )
                            
                            BookGrid(
                                books: books.filter { book in
                                    book.bookStatus == .reading
                                },
                                selectedBook: $selectedBook
                            )
                            .padding(.horizontal)
                        }
                        
                        // Déjà lu
                        VStack(alignment: .leading) {
                            Text("Déjà lu")
                                .font(.title2)
                                .bold()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.gray, lineWidth: 2)
                                )
                            
                            BookGrid(
                                books: books.filter { book in
                                    book.bookStatus == .read
                                },
                                selectedBook: $selectedBook
                            )
                            .padding(.horizontal)
                        }
                        
                        // Read list
                        VStack(alignment: .leading) {
                            Text("Read list")
                                .font(.title2)
                                .bold()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.gray, lineWidth: 2)
                                )
                            
                            BookGrid(
                                books: books.filter { book in
                                    book.bookStatus == .toRead
                                },
                                selectedBook: $selectedBook
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            // MARK: - Navigation vers AddBook
            .navigationDestination(isPresented: $showAddBook) {
                AddBook()
                    .toolbar(.hidden, for: .navigationBar)
            }
            
            // MARK: - Navigation vers ViewBook
            .navigationDestination(item: $selectedBook) { book in
                ViewBook(book: book)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}


// MARK: - Affichage des livres

struct BookGrid: View {
    
    let books: [Book]
    @Binding var selectedBook: Book?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        LazyVGrid(
            columns: columns,
            spacing: 15
        ) {
            
            ForEach(books) { book in
                
                if let imageData = book.image,
                   let uiImage = UIImage(data: imageData) {
                    
                    Button {
                        selectedBook = book // Déclenche l'ouverture de ViewBook
                    } label: {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                    
                } else {
                    Button {
                        selectedBook = book // Déclenche l'ouverture de ViewBook
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                            .frame(height: 150)
                            .overlay {
                                Image(systemName: "book")
                                    .font(.system(size: 35))
                                    .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
    }
}

#Preview{
    MainPage()
}
