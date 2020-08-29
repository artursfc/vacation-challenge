//
//  RecordingsTableViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit
import CoreData
import UserNotifications

class RecordingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var context : NSManagedObjectContext?
    private var recordings : [Recording]?
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorPalette.darkGrey
        tableView.backgroundColor = .clear
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .none
    
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let context = context {
            do {
                recordings = try context.fetch(Recording.fetchRequest()) as? [Recording]
            } catch {
                print(error)
            }
        }
        
    }
    
    


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recordings = recordings else { return 0 }
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecordingsTableViewCell()
        guard let recordings = recordings else { return UITableViewCell() }
        let recording = recordings[indexPath.row]
        guard let cellTextLabel = cell.textLabel else { return UITableViewCell() }
        cellTextLabel.text = recording.name
        cell.backgroundColor = ColorPalette.darkGrey
        guard let recordingPath = recording.path else { return UITableViewCell() }
        cell.setFileName(name: recordingPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            
            let center = UNUserNotificationCenter.current()
            
            guard let recordings = self.recordings else { return }
            let recording = recordings[indexPath.row]
            guard let path = recording.path else { return }
            
            self.context?.delete(recording)
            self.recordings?.remove(at: indexPath.row)
            AudioSession.shared.deleteAudioFile(name: path)
            tableView.deleteRows(at: [indexPath], with: .fade)
            center.removePendingNotificationRequests(withIdentifiers: [path])
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.saveContext()
            
            success(true)
        
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioSession.shared.stopPlaying()
    }

}



