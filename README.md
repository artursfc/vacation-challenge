# Memora
Memora is an iOS app for recording, collecting and remembering audio memories.

1. [Supported iOS version](#supported-ios-version)
2. [App](#app)

## Supported iOS version
* iOS 13+

## App
Memora is developed following a **MVVM-like** architecture with some **UIViewController containment**.
It uses **Core Data** as its persistence layer and **NSFetchedResultsController** to display data.
Recording and playing of memories is implemented using **AVFoundation**, with animations done using
**Core Animation**. Lastly, logging is done through **OSLog**.
