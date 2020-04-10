//
//  SongSegmentController.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class SongController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var summary: UILabel!

    @IBOutlet weak var segmentTableView: UITableView! {
        didSet {
            segmentTableView.delegate = self
            segmentTableView.dataSource = self
        }
    }

    var song: Song! {
        didSet {
            if summary != nil {
                configureSummary()
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song.numOfSegments
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = segmentTableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath)
        guard let segmentCell = cell as? SegmentCell else {
            return cell
        }

        segmentCell.segmentNameLabel.text = song.getSegments()[indexPath.row].name
        return segmentCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecordings", sender: indexPath.row)
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let segment = song.getSegments()[indexPath.row]
            song.removeSegment(segment: segment)
            segmentTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recordingsVC = segue.destination as? RecordingTableController, let index = sender as? Int else {
            return
        }

        recordingsVC.segment = song.getSegments()[index]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = song.name
        configureSummary()
    }


    private func configureSummary() {
        self.summary.text = "\(song.getSegments().count) segments"
    }

    @IBAction func addSegment(_ sender: UIButton) {
        let newSegmentController = NewSegmentController(title: nil, message: nil, preferredStyle: .alert)
        newSegmentController.addSegment = { segmentName in
            self.song.addSegment(segment: SongSegment(name: segmentName))
            self.segmentTableView.reloadData()
            self.configureSummary()
        }
        present(newSegmentController, animated: true)
    }
}
