import Foundation

protocol LibraryBookPersistenceInterface {
    var savedLibraryBooks: [LibraryBook] { get }
    func save(libraryBook: LibraryBook)
    func deleteFile(libraryBook: LibraryBook)
}

final class LibraryBookPersistence: FileStoragePersistence, LibraryBookPersistenceInterface {
    let directoryUrl: URL
    let fileType: String = "json"
    
    init?(atUrl baseUrl: URL, withDirectoryName name: String) {
        guard let directoryUrl = FileManager.default.createDirectory(atUrl: baseUrl, appendingPath: name) else { return nil }
        self.directoryUrl = directoryUrl
    }
    
    var savedLibraryBooks: [LibraryBook] {
        return names.compactMap {
            guard let libraryBookData = read(fileWithId: $0) else { return nil }
            
            return try? JSONDecoder().decode(LibraryBook.self, from: libraryBookData)
        }
    }
    
    func save(libraryBook: LibraryBook) {
        save(object: libraryBook, withId: libraryBook.id.uuidString)
    }
    
    
     func deleteFile(libraryBook: LibraryBook){
        removeFile(withName: libraryBook.id.uuidString)
    }
    
}
