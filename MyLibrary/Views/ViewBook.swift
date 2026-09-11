//
//  AddBook.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftUI
import SwiftData
import PhotosUI
import UniformTypeIdentifiers
import UIKit

struct ViewBook: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showEditBook = false
    
    let book: Book
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - En-tête
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("MyLibrary")
                            .font(.system(size: 30))
                            .bold()
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        showEditBook = true
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 35))
                            .foregroundStyle(.black)
                            .frame(width: 45, height: 45)
                            .padding(.top, 10)
                    }
                }
                
                // MARK: - Informations
                HStack {
                    if let imageData = book.image,
                       let uiImage = UIImage(data: imageData) {
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 100, height: 150)
                            .overlay {
                                Image(systemName: "book")
                                    .font(.system(size: 35))
                                    .foregroundStyle(.gray)
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(book.title)
                            .font(.title)
                            .bold()
                        Text(book.author)
                            .font(.title3)
                            .bold()
                        
                        // MARK: Rating
                        HStack {
                            if book.bookStatus == .read {
                                
                                ForEach(1...5, id: \.self) { star in
                                    
                                    if Double(star) <= book.rating {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.black)
                                    } else {
                                        if Double(star) - 0.5 == book.rating  {
                                            Image(systemName: "star.leadinghalf.filled")
                                                .foregroundStyle(.black)
                                        }
                                        else {
                                            Image(systemName: "star")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                    
                    Spacer()
                }
                
                // MARK: Description
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Description")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 2)
                    
                    Text(book.bookDescription)
                        .font(.system(size: 15))
                        .frame(width: 340)
                        .padding()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 1)
                }
                .padding(.top, 10)
                
                // MARK: Review
                if book.bookStatus == .read {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Review")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 2)
                        
                        Text(book.review)
                            .font(.system(size: 15))
                            .frame(width: 340)
                            .padding()
                        
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    }
                    .padding(.top, 10)
                }
                
                
                Spacer()
            }
            .padding(.horizontal)
            // MARK: - Navigation vers AddBook
            .navigationDestination(isPresented: $showEditBook) {
                EditBook(book: book)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    ViewBook(
        book: Book(
            title: "Harry Potter",
            author: "J.K. Rowling",
            rating: 4.5,
            bookDescription: "Un jeune sorcier découvre le monde de la magie.",
            review: "Très bon livre !",
            bookStatus: .read
        )
    )
}
