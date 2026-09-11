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

struct AddBook: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 0.0
    @State private var bookDescription = ""
    @State private var review = ""
    @State private var bookStatus = BookStatus.toRead
    
    // Image
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showFileImporter = false
    @State private var showPhotoPicker = false
    
    var body: some View {
        ScrollView {
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
                        
                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        guard !trimmedTitle.isEmpty && !trimmedAuthor.isEmpty else {
                            showAlert = true
                            return
                        }
                        
                        let newBook = Book(
                            title: trimmedTitle,
                            author: trimmedAuthor,
                            rating: rating,
                            bookDescription: bookDescription,
                            review: review,
                            image: selectedImageData,
                            bookStatus: bookStatus
                        )
                        
                        modelContext.insert(newBook)
                        dismiss()
                        
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.black)
                            .frame(width: 45, height: 45)
                    }
                    .alert("Champs manquants", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Veuillez renseigner au moins le titre et l'auteur du livre avant d'enregistrer.")
                    }
                }
                
                // MARK: - Image + informations
                HStack {
                    
                    Menu {
                        
                        Button {
                            showFileImporter = true
                        } label: {
                            Label(
                                "Chercher dans Fichiers",
                                systemImage: "folder"
                            )
                        }
                        
                        Button {
                            showPhotoPicker = true
                        } label: {
                            Label(
                                "Chercher dans la galerie",
                                systemImage: "photo"
                            )
                        }
                        
                    } label: {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 100, height: 150)
                            .overlay {
                                
                                if let imageData = selectedImageData,
                                   let uiImage = UIImage(data: imageData) {
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 150)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                    
                                } else {
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .photosPicker(
                        isPresented: $showPhotoPicker,
                        selection: $selectedPhoto,
                        matching: .images
                    )
                    
                    VStack {
                        
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.system(size: 20, weight: .bold))
                            
                            TextField(
                                "Title of the book",
                                text: $title
                            )
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Author")
                                .font(.system(size: 20, weight: .bold))
                            
                            TextField(
                                "Author of the book",
                                text: $author
                            )
                        }
                    }
                    
                    Spacer()
                }
                
                // MARK: - Statut
                VStack(alignment: .leading) {
                    
                    Picker(
                        "Statut",
                        selection: $bookStatus
                    ) {
                        
                        Text("Reading")
                            .tag(BookStatus.reading)
                        
                        Text("Read")
                            .tag(BookStatus.read)
                        
                        Text("Read list")
                            .tag(BookStatus.toRead)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.top, 10)
                
                // MARK: - Description
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Description")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 2)
                    
                    TextEditor(text: $bookDescription)
                        .frame(height: 125)
                        .padding(8)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 1)
                }
                .padding(.top, 10)
                
                // MARK: - Avis + note
                if bookStatus == BookStatus.read {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("My review")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 2)
                        
                        TextEditor(text: $review)
                            .frame(height: 125)
                            .padding(8)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    }
                    .padding(.top, 10)
                    
                    // Étoiles
                    HStack {
                        
                        ForEach(1...5, id: \.self) { star in
                            
                            Image(
                                systemName:
                                    rating >= Double(star)
                                ? "star.fill"
                                : rating >= Double(star) - 0.5
                                ? "star.leadinghalf.filled"
                                : "star"
                            )
                            .font(.system(size: 45))
                            .onTapGesture { location in
                                
                                if location.x < 35 {
                                    rating = Double(star) - 0.5
                                } else {
                                    rating = Double(star)
                                }
                            }
                        }
                    }
                    .padding(8)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            // MARK: - Sélection depuis Fichiers
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.image]
            ) { result in
                
                switch result {
                    
                case .success(let url):
                    selectedImageData = try? Data(contentsOf: url)
                    
                case .failure(let error):
                    print("Erreur lors de l'importation : \(error)")
                }
            }
            
            // MARK: - Sélection depuis la galerie
            .onChange(of: selectedPhoto) {
                
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(
                        type: Data.self
                    ) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
}

#Preview {
    AddBook()
}
