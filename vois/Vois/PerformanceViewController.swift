//
//  PerformanceViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 19/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

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
    var songs = [Song]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = performance.name
        countDownLabel.text = performance.date?.toString
        completionIndicator.progress = Float(performance.getCompleteSongs().count) / Float(performance.numOfSongs)
        songs = performance.getSongs()
        filterControl.selectedSegmentIndex = 0
        songTableView.reloadData()
    }

    @IBAction func filter(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            songs = performance.getSongs()
            songTableView.reloadData()
        case 1:
            songs = performance.getPendingSongs()
            songTableView.reloadData()
        case 2:
            songs = performance.getCompleteSongs()
            songTableView.reloadData()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        guard let songCell = cell as? SongCell else {
            return cell
        }
        songCell.songNameLabel.text = songs[indexPath.row].name

        return songCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let song = songs[indexPath.row]
            performance.removeSong(song: song)
            songTableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSongSegments", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let songVC = segue.destination as? SongController, let index = sender as? Int else {
            return
        }
        songVC.song = songs[index]

    }

    @IBAction func addNewSong(_ sender: UIButton) {
        let newSongController = NewSongViewController(title: nil, message: nil, preferredStyle: .alert)
        newSongController.addSong = { songName in
            self.performance.addSong(song: Song(name: songName))
            self.songs = self.performance.getSongs()
            self.filterControl.selectedSegmentIndex = 0
            self.songTableView.reloadData()
        }
        present(newSongController, animated: true)
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
