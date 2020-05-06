//
//  SuggestionsViewController.swift
//  Vois
//
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var songList: [Track]!
    var artistList: [TrackArtist]!

    @IBOutlet weak var uiTableView: UITableView!

    @IBOutlet weak var uiSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        songList = [Track]()
        uiTableView.delegate = self
        uiTableView.dataSource = self

        updateSongList()
        updateArtistList()

        uiSegmentedControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }

    @objc
    func refreshTable() {
        uiTableView.reloadData()
    }

    @objc
    func updateSongList() {
        LastFMAPInterface().getTopTracks { response in
            if response != nil {
                let newSongList = response!.tracks.track
                self.setSongList(newSongList: newSongList)
            }
        }
    }

    @objc
    func updateArtistList() {
        LastFMAPInterface().getTopArtists { response in
            if response != nil {
                let newArtistList = response!.artists.artist
                self.setArtistList(newArtistList: newArtistList)
            }
        }
    }

    func setSongList(newSongList: [Track]) {
        self.songList = newSongList
        DispatchQueue.main.async {
            self.uiTableView.reloadData()
        }
    }

    func setArtistList(newArtistList: [TrackArtist]) {
        self.artistList = newArtistList
        DispatchQueue.main.async {
            self.uiTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uiSegmentedControl.selectedSegmentIndex == 0 {
            return songList.count
        } else {
            return artistList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = uiTableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)

        if uiSegmentedControl.selectedSegmentIndex == 0 {
            var cellLabelString = songList[indexPath.row].name.capitalized
            cellLabelString += "   (\(songList[indexPath.row].artist.name))"

            cell.textLabel?.text = cellLabelString
        } else {
            var cellLabelString = artistList[indexPath.row].name.capitalized

            cell.textLabel?.text = cellLabelString
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetUrlString = ""

        if uiSegmentedControl.selectedSegmentIndex == 0 {
            targetUrlString = songList[indexPath.row].url
        } else {
            targetUrlString = artistList[indexPath.row].url
        }

        UIApplication.shared.open(
            (URL(string: targetUrlString) ?? URL(string: ""))!,
            options: [UIApplication.OpenExternalURLOptionsKey: Any](),
            completionHandler: nil
        )
    }

//    @objc
//    func getLastFMTopSongs() {
//        let url = "https://ws.audioscrobbler.com/2.0/"
//        let options = [
//            "method": "chart.gettoptracks",
//            "api_key": "5a83c80e13a39002a4c841b72cf8427d",
//            "format": "json"
//        ]
//
//        var completeRequestString = url + "?"
//
//        for (key, value) in options {
//            completeRequestString += (key + "=" + value + "&")
//        }
//
//        if completeRequestString.last == Character("&") {
//            completeRequestString = String(completeRequestString.dropLast())
//        }
//
//        if let url = URL(string: completeRequestString) {
//           URLSession.shared.dataTask(with: url) { data, _, _ in
//              if let data = data {
//                 if let jsonString = String(data: data, encoding: .utf8) {
//                    print(jsonString)
//                 }
//              }
//           }.resume()
//        }
//    }
}
