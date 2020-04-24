//
//  RecordingTableController.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import UIKit

class RecordingTableController: UITableViewController {

    var segment: SongSegment!

    @IBAction func recording(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Recording", sender: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segment.getRecordings().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecordingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        guard let recordingCell = cell as? RecordingCell else {
            return cell
        }

        let recording = segment.getRecordings()[indexPath.row]
        recordingCell.recordingNameLabel.text = recording.name
        recordingCell.playbackDelegate = { self.playback(recording: recording) }
        recordingCell.shareDelegate = {
            self.presentShareRecordingController(for: recording)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            segment.removeRecording(recording: segment.getRecordings()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    private func playback(recording: Recording) {
        guard let viewController = storyboard?.instantiateViewController(
            withIdentifier: "AudioPlaybackController") as? AudioPlaybackController else {
            return
        }

        viewController.recording = recording
        viewController.recordingList = segment.getRecordings()
        recording.updateRecording {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func presentShareRecordingController(for recording: Recording) {
        let link = getShareRecordingLink(for: recording)
        let shareController = ShareRecordingController(title: nil, message: link, preferredStyle: .alert)
        shareController.copyHandler = { self.dismiss(animated: false) }
        present(shareController, animated: true)
    }

    private func getShareRecordingLink(for recording: Recording) -> String {
        //TODO: upload
        return "vois://feedback?recording=\(recording.id ?? "")"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recordingVC = segue.destination as? RecordingViewController,
            let filePath = segment.generateRecordingUrl() else {
            return
        }
        recordingVC.segment = segment
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = segment.name
        tableView.reloadData()
    }

}
