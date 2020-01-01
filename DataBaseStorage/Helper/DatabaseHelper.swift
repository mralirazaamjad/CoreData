//
//  Created by User on 19/12/2019.
//  Copyright (c) 2019 Ali Raza. All rights reserved.
//

import Foundation
import UIKit
import CoreData
    
    struct DatabaseHelper {
        
        static var _managedObjectContext: NSManagedObjectContext? = nil
        static var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
        static var _managedObjectModel: NSManagedObjectModel? = nil
        //MARK: Core Data Stack
        
        static var managedObjectContext:NSManagedObjectContext {
            if (_managedObjectContext == nil) {
                let coordinator:NSPersistentStoreCoordinator? = self.persistentStoreCoordinator
                if (coordinator != nil) {
                    _managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                    _managedObjectContext?.persistentStoreCoordinator = coordinator
                }
            }
            return _managedObjectContext!
        }
        
        static var managedObjectModel: NSManagedObjectModel {
            if (_managedObjectModel == nil) {
                let modelURL = Bundle.main.url(forResource: "DataBaseStorage", withExtension: "momd")
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
            }
            return _managedObjectModel!
        }
        
        
        static var persistentStoreCoordinator:NSPersistentStoreCoordinator {
            if (_persistentStoreCoordinator == nil) {
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                let url: URL? = URL(fileURLWithPath: self.applicationDocumentsDirectory()).appendingPathComponent("DataBaseStorage.sqlite")
                let failureReason = "There was an error creating or loading the application's saved data."
                do {
                    try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
                } catch {
                    // Report any error we got.
                    var dict = [String: AnyObject]()
                    dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                    dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                    
                    dict[NSUnderlyingErrorKey] = error as NSError
                    let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                    // Replace this with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                    abort()
                }
            }
            return _persistentStoreCoordinator!
        }
        
        static func applicationDocumentsDirectory()-> String {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentoryPath = paths[0]
            return documentoryPath
        }
        
        //MARK:IO Operations
        static func save() ->Bool {
            var isSaveData = true
            _managedObjectContext?.perform({
                do {
                    try self.managedObjectContext.save()
                } catch {
                    isSaveData = false
                    print("Unresolved error")
                }
            })
            return isSaveData
        }
        
        static func deleteObjec(_ object:NSManagedObject){
             print("Delete")
            _managedObjectContext?.delete(object)
            _ = self.save()
        }
        
        //MARK: Fetch all record
        static func fetchAllRecords(_ entityName:String, filter:NSPredicate?, sortDiscripter:[NSSortDescriptor], fetchLimit:Int?) -> Array<AnyObject>{
            var allRecords:Array<AnyObject> = []
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            if filter != nil {
                fetchRequest.predicate = filter
            }
            
            if sortDiscripter.count > 0 {
                fetchRequest.sortDescriptors = sortDiscripter
            }
            
            if fetchLimit! > 0 {
                fetchRequest.fetchLimit = fetchLimit!
            }
            
            do {
                allRecords = try DatabaseHelper.managedObjectContext.fetch(fetchRequest)
                // success ...
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
            
            return allRecords;
        }
        

    }
