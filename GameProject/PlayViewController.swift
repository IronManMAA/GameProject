//
//  PlayViewController.swift
//  GameProject
//
//  Created by Marco Almeida on 1/15/17.
//  Copyright © 2017 THE IRON YARD. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class PlayViewController: UIViewController {

    @IBOutlet weak var Player1: UILabel!
    @IBOutlet weak var Player2: UILabel!
    @IBOutlet weak var PlayGame: UIButton!
    @IBOutlet weak var InviteToPlay: UIButton!
    @IBOutlet weak var CancelRequest: UIButton!

    @IBOutlet weak var Question: UITextView!
    @IBOutlet weak var PlayerAnswer: UITextField!
    @IBOutlet weak var OfficialAnswer: UITextField!
    @IBOutlet weak var CorrectSwitch: UISwitch!
    @IBOutlet weak var NewGame: UIButton!
    @IBOutlet weak var PlayAgain: UIButton!
    @IBOutlet weak var YourAnswerLabel: UILabel!
    @IBOutlet weak var OfficialAnswerLabel: UILabel!
    @IBOutlet weak var YesLabel: UILabel!
    @IBOutlet weak var NoLabel: UILabel!
    @IBOutlet weak var SwitchLabel: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    
    
    var refInv: FIRDatabaseReference!
    fileprivate var refInvHandle: FIRDatabaseHandle!
    var refPlay: FIRDatabaseReference!
    fileprivate var refPlayHandle: FIRDatabaseHandle!
    var GameList = Array<FIRDataSnapshot>()

    var aSenderSague = String()
    var aReceiverSague = String()
    var aInviteKeySague = String()
    let myName = AppState.sharedInstance.userName!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Question.isHidden = true
        self.PlayerAnswer.isHidden = true
        self.OfficialAnswer.isHidden = true
        self.CorrectSwitch.isHidden = true
        self.NewGame.isHidden = true
        self.PlayAgain.isHidden = true

        self.YourAnswerLabel.isHidden = true
        self.OfficialAnswerLabel.isHidden = true
        self.YesLabel.isHidden = true
        self.NoLabel.isHidden = true
        self.SwitchLabel.isHidden = true
        self.QuestionLabel.isHidden = true
        
        let aSenderSagueT = self.aSenderSague
        let aReceiverSagueT = self.aReceiverSague
        let aInviteKeySagueT = self.aInviteKeySague
        
        self.PlayGame.isHidden = true
        self.InviteToPlay.isHidden = true
        self.CancelRequest.isHidden = true
        self.Player1.text = aSenderSagueT
        self.Player2.text = aReceiverSagueT
        
    if (aInviteKeySagueT == "0") {
//         print("Invitations")
            self.InviteToPlay.isHidden = false
    } else {
//         print("Play Game")
        if (aSenderSagueT != "" && aReceiverSagueT != "") {
            if (aSenderSagueT == myName) {
                self.CancelRequest.isHidden = false
              } else {
                 self.PlayGame.isHidden = false
              }
            } else {
              self.CancelRequest.isHidden = false
            }
        }
    }

    
    func configureDatabaseGame()
    {
        refPlay = FIRDatabase.database().reference()
        refPlayHandle = refPlay.child("games").observe(.childAdded, with: { (snapshot) -> Void in
        self.GameList.append(snapshot)
print("****************  GameList=>  \(self.GameList)")
            
//            let aGame = snapshot.value as! Dictionary<String, Any>
//            let aP = aPlayer["username"] as! String
            
            //"games": {
            //    "autoGenGameKey": {
            //        "player1": "GitHubUserName",
            //        "player2": "GitHubUserName",
            //        "game rounds": {
            //            "autoGenKey1": {
            //                "question": "Completetheclassicline: That'snomoon;it'sa...",
            //                "correctAnswer": "Spacestation",
            //                "answers": {
            //                    "player1": {
            //                        "answer": "",
            //                        "timeAnswered": "(timestamp)",
            //                        "isCorrect": "boolean"
            //                    },
            //                    "player2": {
            //                        "answer": "",
            //                        "timeAnswered": "(timestamp)",
            //                        "isCorrect": "boolean"

        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PlayGame(_ sender: UIButton)
    {
        configureDatabaseGame()
        print("Play Game")
        self.Question.isHidden = false
        self.PlayerAnswer.isHidden = false
        self.OfficialAnswer.isHidden = false
        self.CorrectSwitch.isHidden = false
        self.NewGame.isHidden = false
        self.PlayAgain.isHidden = false
        self.YourAnswerLabel.isHidden = false
        self.OfficialAnswerLabel.isHidden = false
        self.YesLabel.isHidden = false
        self.NoLabel.isHidden = false
        self.SwitchLabel.isHidden = false
        self.QuestionLabel.isHidden = false
        self.PlayGame.isHidden = true
        self.InviteToPlay.isHidden = true
        self.CancelRequest.isHidden = true        
    }
    @IBAction func NewGame(_ sender: UIButton)
    {
        print("New Game")
    }
    @IBAction func PlayAgain(_ sender: UIButton)
    {
        print("Play Again")
    }
    
    @IBAction func InviteToPlay(_ sender: UIButton)
    {
    print("Invite To Play Game")
        let senderT = myName
        let receiverT = self.aReceiverSague
        let newInvite = ["sender": senderT, "receiver": receiverT]
        refInv = FIRDatabase.database().reference()
        refInv.child("invitations").childByAutoId().setValue(newInvite)
    }

    @IBAction func CancelRequest(_ sender: UIButton)
    {
     if (aInviteKeySague != "0") {
       print("Invite-Key is: \(aInviteKeySague)")
       refInv = FIRDatabase.database().reference()
       refInv.child("invitations").child(aInviteKeySague).removeValue()
      }
    }
    
    
    
}  // end of Class


//"games": {
//    "autoGenGameKey": {
//        "player1": "GitHubUserName",
//        "player2": "GitHubUserName",
//        "game rounds": {
//            "autoGenKey1": {
//                "question": "Completetheclassicline: That'snomoon;it'sa...",
//                "correctAnswer": "Spacestation",
//                "answers": {
//                    "player1": {
//                        "answer": "",
//                        "timeAnswered": "(timestamp)",
//                        "isCorrect": "boolean"
//                    },
//                    "player2": {
//                        "answer": "",
//                        "timeAnswered": "(timestamp)",
//                        "isCorrect": "boolean"
//                    }
//                }
//            },
