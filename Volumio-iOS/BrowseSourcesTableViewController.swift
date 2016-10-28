//
//  BrowseSourcesTableViewController.swift
//  Volumio-iOS
//
//  Created by Federico Sintucci on 01/10/16.
//  Copyright © 2016 Federico Sintucci. All rights reserved.
//

import UIKit

class BrowseSourcesTableViewController: UITableViewController {
    
    var sourcesList : [SourceObject] = []

    override func viewWillAppear(_ animated: Bool) {
        SocketIOManager.sharedInstance.browseSources()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pleaseWait()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("browseSources"), object: nil, queue: nil, using: { notification in
            if let sources = SocketIOManager.sharedInstance.currentSources {
                self.sourcesList = sources
                self.tableView.reloadData()
                self.clearAllNotice()
            }
        })
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.clearAllNotice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "source", for: indexPath)
        let source = sourcesList[indexPath.row]
        
        cell.textLabel?.text = source.name

        return cell
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        SocketIOManager.sharedInstance.browseSources()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFolder" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! BrowseFolderTableViewController
                destinationController.serviceName = sourcesList[indexPath.row].name
                destinationController.serviceUri = sourcesList[indexPath.row].uri
            }
        }
    }

}
