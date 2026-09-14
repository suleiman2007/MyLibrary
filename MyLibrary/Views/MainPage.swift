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
                            
                            HStack {
                                Text("Reading")
                                    .font(.title2)
                                    .bold()
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .init(horizontal: .leading, vertical: .center)
                                    )
                                    .padding()
                                Spacer()
                                
                                Text("\(books.filter { book in book.bookStatus == .reading}.count)")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray, lineWidth: 2)
                            )
                            .padding(.bottom, 5)
                            
                            
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
                            
                            HStack {
                                Text("Read")
                                    .font(.title2)
                                    .bold()
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .init(horizontal: .leading, vertical: .center)
                                    )
                                    .padding()
                                Spacer()
                                
                                Text("\(books.filter { book in book.bookStatus == .read}.count)")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray, lineWidth: 2)
                            )
                            .padding(.bottom, 5)
                            
                            
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
                            
                            HStack {
                                Text("Read List")
                                    .font(.title2)
                                    .bold()
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .init(horizontal: .leading, vertical: .center)
                                    )
                                    .padding()
                                Spacer()
                                
                                Text("\(books.filter { book in book.bookStatus == .toRead}.count)")
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray, lineWidth: 2)
                            )
                            .padding(.bottom, 10)
                            
                            
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

// Extension UIKit pour forcer le swipe-back même lorsque la barre de navigation est masquée (.toolbar(.hidden))
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
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
                        selectedBook = book
                    } label: {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                    }
                    
                } else {
                    Button {
                        selectedBook = book
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
