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

    var performance: Performance = Performance(name: "Test", date: Date(timeIntervalSinceNow: TimeInterval(exactly: 100)!))

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performance.numOfSongs
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        guard let songCell = cell as? SongCell else {
            return cell
        }
        songCell.songNameLabel.text = performance.getSegments()[indexPath.row].name

        return songCell
    }

}
