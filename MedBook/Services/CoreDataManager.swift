//
//  CoreDataManager.swift
//  MedBook
//
//  Created by ParveenKhan on 17/03/25.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "MedBook")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save user to CoreData
    func saveUser(email: String, password: String, country: String) {
        
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

            let user = User(context: context)
            user.email = normalizedEmail
            user.password = normalizedPassword
            user.country = country

            do {
                try context.save()
                print("User saved successfully: \(normalizedEmail) | Password: \(normalizedPassword)")
                printAllUsers() //Debug stored users
            } catch {
                print("Failed to save user: \(error)")
            }
    }

    // Fetch User from CoreData
    func fetchUser(email: String) -> User? {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
            let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", normalizedEmail) // Case-insensitive

            print("🔍 Fetching user with email: \(normalizedEmail)")

            do {
                let result = try context.fetch(fetchRequest)
                if let user = result.first {
                    print("User found: \(user.email ?? "N/A")")
                    return user
                } else {
                    print("No user found with email: \(normalizedEmail)")
                    printAllUsers() //Debug: Print all users
                    return nil
                }
            } catch {
                print("Failed to fetch user: \(error)")
                return nil
            }

    }
    
    func printAllUsers() {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

            do {
                let users = try context.fetch(fetchRequest)
                print("All Users in Core Data:")
                for user in users {
                    print("Email: \(user.email ?? "N/A") | Stored Password: '\(user.password ?? "N/A")'")
                }
            } catch {
                print("Failed to fetch users: \(error)")
            }
    }

    // Check if user exists
    func userExists(email: String) -> Bool  {
        
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", normalizedEmail)

            print("🔍 Checking if user exists with email: \(normalizedEmail)")

            do {
                let result = try context.fetch(fetchRequest)
                if !result.isEmpty {
                    print("User exists: \(normalizedEmail)")
                    return true
                } else {
                    print("User does not exist: \(normalizedEmail)")
                    printAllUsers() //Debug: Print all users
                    return false
                }
            } catch {
                print("Failed to check user existence: \(error)")
                return false
            }
    }
    
    func authenticateUser(email: String, password: String) -> Bool {
        
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", normalizedEmail) //Fetch by email only

            print("Authenticating User: \(normalizedEmail) | Entered Password: \(normalizedPassword)")

            do {
                let result = try context.fetch(fetchRequest)

                if let user = result.first {
                    print("User Found: \(user.email ?? "N/A") | Stored Password: \(user.password ?? "N/A")")

                    if user.password == normalizedPassword { //Compare manually
                        print("Authentication Successful")
                        return true
                    } else {
                        print("Authentication Failed: Password Mismatch")
                        return false
                    }
                } else {
                    print("Authentication Failed: No matching email found")
                    printAllUsers() // Debugging function
                    return false
                }
            } catch {
                print("Authentication Error: \(error)")
                return false
            }
    }
}
