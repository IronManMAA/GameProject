//
//  PlayerTableTableViewController.swift
//  GameProject
//
//  Created by Marco Almeida on 1/14/17.
//  Copyright © 2017 THE IRON YARD. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class PlayerTableViewController: UITableViewController, UITextFieldDelegate {

    var ref: FIRDatabaseReference!
    fileprivate var refHandle: FIRDatabaseHandle!
    var refInv: FIRDatabaseReference!
    fileprivate var refInvHandle: FIRDatabaseHandle!
    var keyArray = [String]()

    var usersList = Array<FIRDataSnapshot>()
    var InvitationsList = Array<FIRDataSnapshot>()
    let myName = AppState.sharedInstance.userName
    var myReqKey = ""
    var mygamesWon = 0

    @IBOutlet weak var makeAvailable: UIButton!
    

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

    func configureDatabaseUsers()
    {
        ref = FIRDatabase.database().reference()
        refHandle = ref.child("users").observe(.childAdded, with: { (snapshot) -> Void in
        self.usersList.append(snapshot)
        let aPlayer = snapshot.value as! Dictionary<String, Any>
        let aP = aPlayer["username"] as! String
        if (aP == self.myName ) {
            AppState.sharedInstance.myReqKey = snapshot.key
            self.myReqKey = snapshot.key
            self.mygamesWon = aPlayer["gameswon"] as! Int
        }
        let indexPath = IndexPath(row: self.usersList.count-1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//print("*********************************  usersList = \(self.usersList)")
        })
        refInv = FIRDatabase.database().reference()
        refInvHandle = refInv.child("invitations").observe(.childAdded, with: { (snapshot2) -> Void in
//print("*********************************  InvitationsList = \(snapshot2)")
        let invKey = snapshot2.key
        self.keyArray.append(invKey)
        self.InvitationsList.append(snapshot2)
        let indexPath = IndexPath(row: self.InvitationsList.count-1, section: 1)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//print("*********************************  InvitationsList = \(self.InvitationsList)")
            //    print("*********************************  aUser = \(snapshot)")
        })
    }
    
    @IBAction func makeAvailable(_ sender: UIButton)
    {
        let bLabel = makeAvailable.titleLabel?.text
        if bLabel == "Make me Un-Available" {
            if (self.myReqKey != "") {
                print("my User-Key is: \(self.myReqKey)")
                let nameT = myName
                let usernameT = myName
                let availableT = false
                let gameswonT = self.mygamesWon
                let updateUser = ["name": nameT!, "username": usernameT!, "available":availableT, "gameswon":gameswonT] as [String : Any]
                refInv = FIRDatabase.database().reference()
                refInv.child("users").child(self.myReqKey).setValue(updateUser)
                makeAvailable.setTitle("Make me Available",for: .normal)
            }
            
        } else {
            if (self.myReqKey != "") {
                print("my User-Key is: \(self.myReqKey)")
                let nameT = myName
                let usernameT = myName
                let availableT = true
                let gameswonT = self.mygamesWon
                let updateUser = ["name": nameT!, "username": usernameT!, "available":availableT, "gameswon":gameswonT] as [String : Any]
                refInv = FIRDatabase.database().reference()
                refInv.child("users").child(self.myReqKey).setValue(updateUser)
                makeAvailable.setTitle("Make me Un-Available",for: .normal)
             }
        } 
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return usersList.count
        }
        else
        {
            return InvitationsList.count
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Player Available \n "
        } else {
            return "Pending Requests To Play"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
 
        if indexPath.section == 0
        {
          let playerSnapshot = usersList[indexPath.row]
          let aPlayer = playerSnapshot.value as! Dictionary<String, Any>

//            print("*********************************  usersList = \(self.usersList)")
            
          let nameT = aPlayer["username"] as! String
          let aT  = aPlayer["available"] as? Bool
          var availT = ""
          if (aT == true) {
            availT = "Available"
            } else {
            availT = "Not Available"
          }
          if (nameT == myName) {
                if (aT == true) {
                   makeAvailable.setTitle("Make me Un-Available",for: .normal)
                } else {
                    makeAvailable.setTitle("Make me Available",for: .normal)
                }
           }
          cell.textLabel?.text = "\(nameT) is \(availT)"
        }
        if indexPath.section == 1
        {
            let inviteSnapshot = InvitationsList[indexPath.row]
            let aInvite = inviteSnapshot.value as! Dictionary<String, Any>
            let aKey = keyArray[indexPath.row]
            let sender = aInvite["sender"] as! String
            let receiver = aInvite["receiver"] as! String
            var statusT = ""
            if (sender == myName) {
                statusT = "You Invited \(receiver)"
            } else {
                if (receiver == myName) {
                statusT = "\(sender) Is Inviting You"
            } else {
                statusT = "\(sender) Is Inviting \(receiver)"
            }
            }
            
//    print("**** sender: \(sender), receiver: \(receiver), Key: \(aKey)")
            
            cell.textLabel?.text = statusT
            cell.detailTextLabel?.text = "Your Invitation: \(aKey)"
            
        }

        return cell
    }
        
        
// MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySague"
        {
            let destinationVC = segue.destination as! PlayViewController
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                if selectedIndexPath.section==0 {
                    let playerSnapshot = usersList[selectedIndexPath.row]
                    let aPlayer = playerSnapshot.value as! Dictionary<String, Any>
                    let nameT = aPlayer["username"] as! String
                    destinationVC.aInviteKeySague = "0"
                    destinationVC.aSenderSague = myName!
                    destinationVC.aReceiverSague = nameT
                } else {
                    let aPlayerInviteSnapshot = InvitationsList[selectedIndexPath.row]
                    let aPlayer = aPlayerInviteSnapshot.value as! Dictionary<String, Any>
                    let aKey = keyArray[selectedIndexPath.row]
                    destinationVC.aInviteKeySague = aKey
                    destinationVC.aSenderSague = aPlayer["sender"] as! String
                    destinationVC.aReceiverSague = aPlayer["receiver"] as! String
                }
                navigationItem.title = nil
            }
        }
    
    
    
//    if segue.identifier == "PlaySague"
//    {
//     if let selectedIndexPath = tableView.indexPathForSelectedRow {
//        let aTeam = playersDictionarie[selectedIndexPath.row]
//        let nameT = aTeam["username"]
//        let nameKey = aTeam["namekey"]
//
//        //      ["namekey":nameKey,"username":username,"available": available,"gameswon": gameswon]
//        if let destinationVC = segue.destination as? PlayViewController {
//          destinationVC.playerIDSague = nameKey as! String
//          destinationVC.playerNameSague = nameT as! String
//            let cr = tableView.cellForRow(at: selectedIndexPath)
//          destinationVC.inviteStatusSague = (cr?.detailTextLabel?.text)!
//       }
//     }
//    }
  }

    
func createnewRecords() {
        
        //            let nameT = myName
        //            let usernameT = myName
        //            let availableT = 1
        //            let gameswonT = 0
        //            let newUser = ["name": nameT!, "username": usernameT!, "available":availableT, "gameswon":gameswonT] as [String : Any]
        //            ref.child("users").childByAutoId().setValue(newUser)
        
//                    let senderT = myName
// //                   let receiverT = "Ben Gohlke"
//                    let receiverT = "Moa"
//                    let newInvite = ["sender": senderT, "receiver": receiverT]
//                    refInv.child("invitations").childByAutoId().setValue(newInvite)
        //
    }
    
    
} // End of Class



//    "FirebaseGenNode": {
//    "invitations": {
//    "autoGenKeyInvite": {
//    "sender": "GitHubUserName",
//    "receiver": "GitHubUserName"
//    }

//            "users": {
//                "autoGenUserKey": {
//                    "name": "Linsy Joyner",
//                    "username": "GitHubUserName",
//                    "available": "true",
//                    "gameswon": 4
//                }

