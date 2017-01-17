//
//  ScoreBoardTableViewController.swift
//  GameProject
//
//  Created by Marco Almeida on 1/16/17.
//  Copyright © 2017 THE IRON YARD. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ScoreBoardTableViewController: UITableViewController {

    
    var ref: FIRDatabaseReference!
    fileprivate var refHandle: FIRDatabaseHandle!
    var usersList = Array<FIRDataSnapshot>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configureDatabaseUsers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Star Wars Game"
    }

    
//    override func viewWillAppear(animated: Bool) {
//        navigationItem.title = "Back"
//    }
    
    func configureDatabaseUsers()
    {
        ref = FIRDatabase.database().reference()
        refHandle = ref.child("users").observe(.childAdded, with: { (snapshot) -> Void in
            self.usersList.append(snapshot)
            let indexPath = IndexPath(row: self.usersList.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCellBS", for: indexPath)
        if indexPath.section == 0 {
            let playerSnapshot = usersList[indexPath.row]
            let aPlayer = playerSnapshot.value as! Dictionary<String, Any>
        
//        print("*********************************  aPlayer = \(aPlayer)")
        
            let nameT = aPlayer["username"]
            let gamesWonT = aPlayer["gameswon"]
            let s = String(describing: gamesWonT!)

            print("*********************************  gamesWonT = \(s)")
            
            cell.textLabel?.text = nameT as! String?
            cell.detailTextLabel?.text = s
        }
        return cell
    }
    
    
} // End of Class
