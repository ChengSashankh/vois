//
//  SuggestionsViewController.swift
//  Vois
//
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class TrendingSongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var songList: [Track]!
    var artistList: [TrackArtist]!

    var regionalSongList: [Track]!
    var regionalArtistList: [TrackArtist]!

    var countryList = Locale.isoRegionCodes.compactMap {
        Locale.current.localizedString(forRegionCode: $0)
    }

    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var uiLocationPicker: UISegmentedControl!
    @IBOutlet weak var uiSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view data sources
        songList = [Track]()
        regionalSongList = [Track]()

        artistList = [TrackArtist]()
        regionalArtistList = [TrackArtist]()

        uiTableView.delegate = self
        uiTableView.dataSource = self

        updateSongList()
        updateArtistList()

        uiSegmentedControl.addTarget(
            self,
            action: #selector(refreshTable),
            for: .valueChanged
        )

        uiLocationPicker.addTarget(
            self,
            action: #selector(refreshTable),
            for: .valueChanged
        )
    }

    /*************** Setter Methods *****************/

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

    func setRegionalSongList(newSongList: [Track]) {
        self.regionalSongList = newSongList
        DispatchQueue.main.async {
            self.uiTableView.reloadData()
        }
    }

    func setRegionalArtistList(newArtistList: [TrackArtist]) {
        self.regionalArtistList = newArtistList
        DispatchQueue.main.async {
            self.uiTableView.reloadData()
        }
    }

    /*************** Data  Update Methods *****************/

    @objc
    func refreshTable() {
        uiTableView.reloadData()
    }

    @objc
    func updateSongList() {
        APIClient().getTopTracks { response in
            if response != nil {
                let newSongList = response!.tracks.track
                self.setSongList(newSongList: newSongList)
            }
        }
        APIClient().getTopTracksByRegion(country: "Singapore") { response in
            if response != nil {
                let newSongList = response!.tracks.track
                self.setRegionalSongList(newSongList: newSongList)
            }
        }
    }

    @objc
    func updateArtistList() {
        APIClient().getTopArtists { response in
            if response != nil {
                let newArtistList = response!.artists.artist
                self.setArtistList(newArtistList: newArtistList)
            }
        }
        APIClient().getTopArtistsByRegion(country: "Singapore") { response in
            if response != nil {
                let newArtistList = response!.topartists.artist
              self.setRegionalArtistList(newArtistList: newArtistList)
            }
        }
    }

    /*************** Table View Methods *****************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uiSegmentedControl.selectedSegmentIndex == 0 {
            if uiLocationPicker.selectedSegmentIndex == 0 {
                return regionalSongList.count
            } else {
                return songList.count
            }
        } else {
            if uiLocationPicker.selectedSegmentIndex == 0 {
                return regionalArtistList.count
            } else {
                return artistList.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = uiTableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)

        if uiSegmentedControl.selectedSegmentIndex == 0 {
            var song: Track?

            if uiLocationPicker.selectedSegmentIndex == 0 {
                song = regionalSongList[indexPath.row]
            } else {
                song = songList[indexPath.row]
            }

            let cellLabelString = "\(indexPath.row + 1). \(song!.name.capitalized)   (\(song!.artist.name))"
            cell.textLabel?.text = cellLabelString
            cell.textLabel?.textColor = .blue
        } else {
            var artist: TrackArtist?

            if uiLocationPicker.selectedSegmentIndex == 0 {
                artist = regionalArtistList[indexPath.row]
            } else {
                artist = artistList[indexPath.row]
            }

            let cellLabelString = "\(indexPath.row + 1). \(artist!.name.capitalized)"
            cell.textLabel?.text = cellLabelString
            cell.textLabel?.textColor = .blue
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetUrlString = ""

        if uiSegmentedControl.selectedSegmentIndex == 0 {
            var song: Track?

            if uiLocationPicker.selectedSegmentIndex == 0 {
                song = regionalSongList[indexPath.row]
            } else {
                song = songList[indexPath.row]
            }

            targetUrlString = song!.url
        } else {
            var artist: TrackArtist?

            if uiLocationPicker.selectedSegmentIndex == 0 {
                artist = regionalArtistList[indexPath.row]
            } else {
                artist = artistList[indexPath.row]
            }

            targetUrlString = artist!.url
        }

        UIApplication.shared.open(
            (URL(string: targetUrlString) ?? URL(string: ""))!,
            options: [UIApplication.OpenExternalURLOptionsKey: Any](),
            completionHandler: nil
        )
    }
}
