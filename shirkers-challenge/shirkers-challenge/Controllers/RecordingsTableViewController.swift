//
//  RecordingsTableViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 25/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import CoreData

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
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -50).isActive = true

        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(RecordingsTableViewCell.self, forCellReuseIdentifier: "cell")
        
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecordingsTableViewCell()
        guard let recordings = recordings else { return UITableViewCell() }
        guard let recording = recordings[indexPath.row] as? Recording else { return UITableViewCell() }
        guard let cellTextLabel = cell.textLabel else { return UITableViewCell() }
        cellTextLabel.text = recording.name
        cell.backgroundColor = ColorPalette.darkGrey
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

}



