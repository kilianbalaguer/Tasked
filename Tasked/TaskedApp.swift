//
//  TaskedApp.swift
//  Tasked
//
//  Created by Kilian Balaguer on 03/12/2024.
//

import SwiftUI

@main
struct TaskedApp: App {
    init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate()

        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if let error = error {
                print("Failed to request authorization for notifications: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(success)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // Show the notification even if the app is in the foreground
        return [.banner, .sound, .badge]
    }
}
