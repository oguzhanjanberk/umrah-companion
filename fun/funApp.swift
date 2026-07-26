//
//  funApp.swift
//  fun
//
//  Created by Oguzhan Janberk on 19/07/2026.
//

import SwiftUI

@main
struct funApp: App {
    @State private var settings = AppSettings()
    @State private var queues = QueueStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .environment(queues)
        }
    }
}
