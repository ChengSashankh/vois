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
    var recordingPaths = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecordings()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func loadRecordings() {
        let recordingPaths = RecordingTable.fetchRecordings()
        self.recordingPaths = recordingPaths
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordingPaths.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let text = recordingPaths[indexPath.row]
        cell.textLabel?.text = text.lastPathComponent
        cell.textLabel?.textAlignment = .center

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "AudioPlaybackController") as? AudioPlaybackController else {
            return
        }
        let url = recordingPaths[indexPath.row]
        viewController.setAudioURL(url: url, recordingList: recordingPaths)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
