//
//  ChangeBook.swift
//  mylibrary
//
//  Created by MAGOMADOV on 03/09/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditBook: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // On récupère directement le livre à modifier
    @Bindable var book: Book
    
    // États locaux pour les sélections d'images (si l'utilisateur veut changer l'image)
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showFileImporter = false
    @State private var showPhotoPicker = false
    
    @State private var showDeleteAlert = false
    @State private var showMainPage = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - En-tête
                HStack {
                    Text("Edit Book")
                        .font(.system(size: 26))
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.red)
                            .frame(width: 45, height: 45)
                    }
                    .alert("Supprimer le livre", isPresented: $showDeleteAlert) {
                        Button("Annuler", role: .cancel) {}
                        Button("Supprimer", role: .destructive) {
                            modelContext.delete(book)
                            showMainPage = true
                        }
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.black)
                            .frame(width: 45, height: 45)
                    }
                }
                
                // MARK: - Image + informations (Titre, Auteur)
                HStack {
                    Menu {
                        Button { showFileImporter = true } label: {
                            Label("Chercher dans Fichiers", systemImage: "folder")
                        }
                        Button { showPhotoPicker = true } label: {
                            Label("Chercher dans la galerie", systemImage: "photo")
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 100, height: 150)
                            .overlay {
                                if let imageData = book.image,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
                    
                    VStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Titre")
                                .bold()
                            TextField("Titre du livre", text: $book.title)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Auteur").bold()
                            TextField("Auteur du livre", text: $book.author)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    Spacer()
                }
                
                // MARK: - Statut
                Picker("Statut", selection: $book.bookStatus) {
                    Text("En train de lire")
                        .tag(BookStatus.reading)
                    Text("Déjà lu")
                        .tag(BookStatus.read)
                    Text("Read list")
                        .tag(BookStatus.toRead)
                }
                .pickerStyle(.segmented)
                .padding(.top, 10)
                
                // MARK: - Description
                VStack(alignment: .leading, spacing: 0) {
                    Text("Description")
                        .font(.system(size: 18, weight: .bold))
                        .padding(8)
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 2)
                    TextEditor(text: $book.bookDescription)
                        .frame(height: 100)
                }
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
                .padding(.top, 10)
                
                // MARK: - Avis + note (si déjà lu)
                if book.bookStatus == .read {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Mon avis")
                            .font(.system(size: 18, weight: .bold))
                            .padding(8)
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 2)
                        
                        TextEditor(text: $book.review)
                            .frame(height: 100)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .padding(.top, 10)
                    
                    // Étoiles interactives
                    HStack {
                        
                        ForEach(1...5, id: \.self) { star in
                            
                            Image(
                                systemName:
                                    book.rating >= Double(star)
                                    ? "star.fill"
                                    : book.rating >= Double(star) - 0.5
                                    ? "star.leadinghalf.filled"
                                    : "star"
                            )
                            .font(.system(size: 50))
                            .onTapGesture { location in
                                
                                if location.x < 35 {
                                    book.rating = Double(star) - 0.5
                                } else {
                                    book.rating = Double(star)
                                }
                            }
                        }
                    }
                    .padding(.top, 30)
                }
                
            Spacer()

            }
            .padding()
            .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image]) { result in
                if case .success(let url) = result {
                    book.image = try? Data(contentsOf: url)
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                        book.image = data
                    }
                }
            }
            
            // MARK: - Navigation vers MainPage
            .navigationDestination(isPresented: $showMainPage) {
                MainPage()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    EditBook(
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
