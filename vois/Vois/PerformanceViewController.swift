//
//  PerformanceViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 19/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Firebase

class PerformanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var completionIndicator: UIProgressView!

    @IBOutlet weak var countDownLabel: UILabel!

    @IBOutlet weak var filterControl: UISegmentedControl!

    @IBOutlet weak var songTableView: UITableView! {
        didSet {
            songTableView.delegate = self
            songTableView.dataSource = self
        }
    }

    var performance: Performance!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = performance.name
        countDownLabel.text = performance.date?.timeIntervalSinceNow.toDayHour
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performance.numOfSongs
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        guard let songCell = cell as? SongCell else {
            return cell
        }
        songCell.songNameLabel.text = performance.getSongs()[indexPath.row].name
        songCell.startRecording = { songName in
            self.performSegue(withIdentifier: "Recording", sender: songName)
        }

        songCell.startPlayback = { songName in
            self.performSegue(withIdentifier: "Playback", sender: songName)
        }

        songCell.shareRecording = { songName in
            self.presentShareRecordingController(for: songName)
        }

        return songCell
    }

    private func presentShareRecordingController(for songName: String) {
        guard let link = getShareRecordingLink(for: songName) else {
            return
        }
        let shareController = ShareRecordingController(title: nil, message: link, preferredStyle: .alert)
        shareController.copyHandler = { self.dismiss(animated: false) }
        present(shareController, animated: true)
    }

    private func getShareRecordingLink(for songName: String) -> String? {
        guard let userName = UserSession.currentUserName else {
            return nil
        }
        return "vois://feedback?user=\(userName)&performance=\(performance.name)&song=\(songName)"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let userName = UserSession.currentUserName else {
                return
            }
            let song = performance.getSongs()[indexPath.row]
            performance.removeSong(song: song)
            songTableView.deleteRows(at: [indexPath], with: .automatic)
            PerformanceFilesDirectory.updatePerformance(for: userName, performance: performance)
            PerformanceFilesDirectory.removeSong(for: userName, performanceName: performance.name, songName: song.name)
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordingVC = segue.destination as? RecordingViewController {
            guard let songName = sender as? String else {
                return
            }
            recordingVC.performanceName = performance.name
            recordingVC.songName = songName
        } else if let recordingTableVC = segue.destination as? RecordingTableController {
            guard let songName = sender as? String else {
                return
            }
            recordingTableVC.songName = songName
            recordingTableVC.performanceName = performance.name
        }
    }

    @IBAction func addNewSong(_ sender: UIButton) {
        let newSongController = NewSongViewController(title: nil, message: nil, preferredStyle: .alert)
        newSongController.addSong = { songName in
            guard let userName = UserSession.currentUserName else {
                return
            }
            self.performance.addSong(song: Song(name: songName))
            PerformanceFilesDirectory.updatePerformance(for: userName, performance: self.performance)
            self.songTableView.reloadData()
        }
        present(newSongController, animated: true)
    }

    @IBAction func promptSharing(_ sender: UIButton) {
        let alert = UIAlertController(title: "Share Performance",
                                      message: "Enter email.",
                                      preferredStyle: .alert)
        alert.addTextField { $0.text = "" }
        alert.addAction(UIAlertAction(title: "Invite", style: .default) { [weak alert] _ in
            guard let email = alert?.textFields?[0].text else {
                fatalError("Could not retrieve input from the email text field.")
            }
            self.addEditor(email: email)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func addEditor(email: String) {
        
        let emailsToUIDs = Firestore.firestore().collection("emailsToUIDs").document(email)

        emailsToUIDs.getDocument { document, _ in
            if let document = document, document.exists {
                guard let uid = document.data()?["uid"] as? String else {
                    return
                }
                self.performance.addEditor(uid: uid)

                let users = Firestore.firestore().collection("users").document(uid)

                users.getDocument { document, _ in
                    if let document = document, document.exists {
                        guard var performances = document.data()?["performances"] as? [String] else {
                            return
                        }
                        print(self.performance.uid)
                        performances.append("performances/" + self.performance.uid)
                        users.updateData(["performances": performances])
                    }
                }
            } else {
                print("No UID associated with this email.")
            }
        }
        /*
        let emailsToUIDs = Firestore.firestore().collection("emailsToUIDs")
        let firestoreAdapter = FirestoreAdapter()
        guard let uid = try? firestoreAdapter.readObject(
         inCollection: "emailsToUIDs",
         withId: email)["uid"] as? String else {
            print(try? firestoreAdapter.readObject(inCollection: "emailsToUIDs", withId: email))
            return
        }
        self.performance.addEditor(uid: uid)
        */
    }
}

extension TimeInterval {

    var toDayHour: String {
        let secondsPerDay = 24 * 60 * 60
        let secondsPerHour = 24 * 60
        let days = Int((self / Double(secondsPerDay)))
        let hours = Int((self - Double(secondsPerDay * days)) / Double(secondsPerHour))
        return "\(days) days \(hours) hours"
    }
}

extension PerformanceFilesDirectory {
    static func updatePerformance(for userName: String, performance: Performance) {
        try? savePerformanceFile(name: performance.name, with: performance.encodeToJson(), for: userName)
    }
}
