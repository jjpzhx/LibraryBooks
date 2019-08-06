import Foundation

// Application Session singleton
class ApplicationSession {
    static let sharedInstance = ApplicationSession()
    
    var persistence: LibraryBookPersistenceInterface?
    
    private init() {
        if let appStorageUrl = FileManager.default.createDirectoryInUserLibrary(atPath: "LibraryBookApp"),
            let persistence = LibraryBookPersistence(atUrl: appStorageUrl, withDirectoryName: "librarybooks") {
            self.persistence = persistence
        }
    }
}
