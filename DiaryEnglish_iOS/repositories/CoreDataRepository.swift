//
//  CoreDataRepository.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/28.
//

import Foundation
import CoreData

class CoreDataRepository {
    static let shared = CoreDataRepository()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func createEntity<T: NSManagedObject>() -> T {
        T(context: persistentContainer.viewContext)
    }
    
    func save<T: NSManagedObject>(entity: T) {
        persistentContainer.viewContext.insert(entity)
        saveContext()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updateContext(requestDiaryData: RequestDiaryData) {
        let fetchRequest = NSFetchRequest<Diary>(entityName: String(describing: Diary.self))
        fetchRequest.predicate = NSPredicate(format: "%K = %@","id","\(requestDiaryData.id)")
        do {
            let diaries = try persistentContainer.viewContext.fetch(fetchRequest)
            if let updateData = diaries.first(where: { $0.id == requestDiaryData.id }) {
                updateData.setValue(requestDiaryData.japanese, forKey: "japanese")
                updateData.setValue(requestDiaryData.english, forKey: "english")
                updateData.setValue(requestDiaryData.situation, forKey: "situation")
                updateData.setValue(requestDiaryData.wantToSay, forKey: "wantToSay")
                saveContext()
            }
        } catch {
            fatalError("Invalid deleteData.")
        }
    }
    
    func fetchEntities<T: NSManagedObject>() -> [T] {
        do {
            return try persistentContainer.viewContext.fetch(NSFetchRequest<T>(entityName: String(describing: T.self)))
        } catch {
            return []
        }
    }
    
    func deleteEntities(id: String) {
        let fetchRequest = NSFetchRequest<Diary>(entityName: String(describing: Diary.self))
        fetchRequest.predicate = NSPredicate(format: "%K = %@","id","\(id)")
        do {
            let diaries = try persistentContainer.viewContext.fetch(fetchRequest)
            if let deleteData = diaries.first(where: { $0.id == id }) {
                persistentContainer.viewContext.delete(deleteData)
                saveContext()
            }
        } catch {
            fatalError("Invalid deleteData.")
        }
    }
}
