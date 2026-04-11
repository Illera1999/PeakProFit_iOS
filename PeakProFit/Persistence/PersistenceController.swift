import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    private var didRetryAfterMigrationFailure = false

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PeakProFit")

        for description in container.persistentStoreDescriptions {
            if inMemory {
                description.url = URL(fileURLWithPath: "/dev/null")
            }
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }

        loadStores()

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    private func loadStores() {
        container.loadPersistentStores { [weak self] _, error in
            if let error = error as NSError? {
                if self?.recoverFromMigrationFailureIfPossible(error) == true {
                    return
                }
                fatalError("CoreData store failed to load: \(error), \(error.userInfo)")
            }
        }
    }

    private func recoverFromMigrationFailureIfPossible(_ error: NSError) -> Bool {
#if DEBUG
        guard !didRetryAfterMigrationFailure else { return false }
        guard error.code == 134140 || error.code == 134110 else { return false }
        guard let storeURL = container.persistentStoreDescriptions.first?.url else { return false }

        didRetryAfterMigrationFailure = true
        do {
            let coordinator = container.persistentStoreCoordinator
            try coordinator.destroyPersistentStore(at: storeURL, type: .sqlite)
            loadStores()
            print("[PersistenceController] Reset local CoreData store after migration failure (DEBUG only).")
            return true
        } catch {
            print("[PersistenceController] Failed to reset store: \(error.localizedDescription)")
            return false
        }
#else
        return false
#endif
    }
}
