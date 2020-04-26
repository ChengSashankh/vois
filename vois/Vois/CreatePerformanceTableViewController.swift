//
//  CreatePerformanceTableViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 17/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class CreatePerformanceTableViewController: UITableViewController, UITextFieldDelegate {

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    private var songs = [Song]()
    private var eventName: String?
    private var date: Date?
    private var isShowingDatePicker = false
    var performances: Performances!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return isShowingDatePicker ? 2 : 1
        case 2:
            return songs.count + 1
        default:
            return 0
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        eventName = textField.text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func getEventNameCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventNameCell", for: indexPath)

        guard let eventNameCell = cell as? EventNameCell else {
            return cell
        }
        eventNameCell.eventName.delegate = self
        return eventNameCell
    }

    private func getDateCell(for indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row == 0 else {
            return getDatePickerCell(for: indexPath)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)

        guard let dateCell = cell as? DateCell else {
            return cell
        }

        dateCell.dateLabel.text = date?.toString ?? "Choose date"
        dateCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleDatePicker)))
        return dateCell
    }

    @objc
    private func toggleDatePicker() {
        if isShowingDatePicker {
            isShowingDatePicker = false
            tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        } else {
            isShowingDatePicker = true
            tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        }
    }

    private func getDatePickerCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath)
        guard let datePickerCell = cell as? DatePickerCell else {
            return cell
        }

        if let selectedDate = date {
            datePickerCell.datePicker.date = selectedDate
        }
        datePickerCell.dateValueChangedHandler = dateValueChanged(to:)

        return datePickerCell
    }

    private func dateValueChanged(to date: Date) {
        guard let dateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DateCell else {
            return
        }
        self.date = date
        dateCell.dateLabel.text = date.toString
    }

    private func getSongCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongNameCell", for: indexPath)
        guard let songNameCell = cell as? SongNameCell else {
            return cell
        }
        if isSongNameCell(indexPath: indexPath) {
            songNameCell.songNameLabel.text = songs[indexPath.row].name
            songNameCell.songNameTextField.text = songs[indexPath.row].name
            songNameCell.setNonEditingMode()
        } else {
            songNameCell.setEditingMode()
            songNameCell.songNameTextField.text = ""
            songNameCell.shouldEndEditingHandler = { true }
            songNameCell.endEditingHandler = { songName in
                guard !songName.isEmpty else {
                    return
                }
                self.songs.append(Song(name: songName))
                songNameCell.setNonEditingMode()
                self.tableView.insertRows(at: [IndexPath(row: self.songs.count, section: 2)], with: .none)
                songNameCell.endEditingHandler = nil
                songNameCell.shouldEndEditingHandler = nil
           }
        }

        return songNameCell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return getEventNameCell(for: indexPath)
        case 1:
            return getDateCell(for: indexPath)
        case 2:
            return getSongCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Event name"
        case 1:
            return "Date"
        case 2:
            return "Songs"
        default:
            return nil
        }
    }

    private func isSongNameCell(indexPath: IndexPath) -> Bool {
        return indexPath.section == 2 && indexPath.row < songs.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let songNameCell = tableView.cellForRow(at: indexPath) as? SongNameCell else {
            return
        }
        songNameCell.setEditingMode()
        songNameCell.endEditingHandler = { songName in
            songNameCell.setNonEditingMode()
            self.songs.append(Song(name: songName))
//            self.songs[indexPath.row].name = songName
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isSongNameCell(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            songs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction private func createPerformance(_ sender: Any) {
        guard let name = eventName else {
                return
            }
        let performance = Performance(name: name, date: date)
        for song in songs {
            performance.addSong(song: song)
        }
        performances.addPerformance(performance: performance)
        navigationController?.popViewController(animated: true)
    }
}
