//
//  RecordingViewController.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 15.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import AVFoundation
import Charts

class RecordingViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    var recordingController: RecordingController!
    var playbackController: PlaybackController!
    var recordingCount = 0
    var recordingDurationTimer: Timer!
    var recordingPowerTimer: Timer!
    var recordings: [URL]!
    var xIndex: Int!

    @IBOutlet weak var uiLineChartView: LineChartView!
    @IBOutlet weak var uiRecordButton: UIButton!
    @IBOutlet weak var uiTimeLabel: UILabel!
    @IBOutlet weak var uiTableView: UITableView!
    
    func setUpLineChart() {
        // Set up line chart
        uiLineChartView.delegate = self
        xIndex = 0
        let powerValues = [ChartDataEntry]()
        let powerData = LineChartDataSet(entries: powerValues, label: "")
        let powerDataNegative = LineChartDataSet(entries: powerValues, label: "")

        powerData.drawCirclesEnabled = false
        powerData.setColor(.blue)
        powerData.fill = Fill.fillWithColor(.blue)
        powerData.drawFilledEnabled = true
        powerData.drawValuesEnabled = false
        powerData.mode = .cubicBezier

        powerDataNegative.drawCirclesEnabled = false
        powerDataNegative.setColor(.blue)
        powerDataNegative.fill = Fill.fillWithColor(.blue)
        powerDataNegative.drawFilledEnabled = true
        powerDataNegative.drawValuesEnabled = false
        powerDataNegative.mode = .cubicBezier

        let dataSet = LineChartData(dataSets: [powerData, powerDataNegative])

        uiLineChartView.data = dataSet
        uiLineChartView.legend.enabled = false
        uiLineChartView.xAxis.drawGridLinesEnabled = false
        uiLineChartView.xAxis.drawAxisLineEnabled = false
        uiLineChartView.xAxis.drawLabelsEnabled = false
        uiLineChartView.rightAxis.enabled = false
        uiLineChartView.leftAxis.enabled = false
        uiLineChartView.leftAxis.axisMinimum = -100.0
        uiLineChartView.leftAxis.axisMaximum = 100.0
        uiLineChartView.rightAxis.axisMinimum = -100.0
        uiLineChartView.rightAxis.axisMaximum = 100.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingController = RecordingController()
        refreshRecordings()

        if let storedRecordingCount: Int = UserDefaults.standard.object(forKey: "recordingCount") as? Int {
            recordingCount = storedRecordingCount
            recordingController = RecordingController(recordingCounter: recordingCount)
        }

        setUpLineChart()
    }

    @IBAction private func onRecordButtonTap(_ sender: UIButton) {
        if recordingController.recordingInProgress {
            stopRecording()
            showSaveModal()
            sender.setImage(UIImage(named: "Record Button.png"), for: .normal)
        } else {
            startRecording()
            sender.setImage(UIImage(named: "Stop Button.png"), for: .normal)
        }
    }

    func showSaveModal() {
        let saveViewController: SaveViewController? =
            storyboard!.instantiateViewController(withIdentifier: "saveViewController") as? SaveViewController
        saveViewController!.delegate = self
        saveViewController!.filePath = recordingController.audioRecorder.url
        saveViewController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(saveViewController!, animated: true, completion: nil)
    }

    func startRecordingDurationTimer() {
        recordingDurationTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.updateRecordingDuration),
            userInfo: nil,
            repeats: true
        )
    }

    func startRecordingPowerTimer() {
        recordingPowerTimer = Timer.scheduledTimer(
            timeInterval: 0.016,
            target: self,
            selector: #selector(self.updateRecordingPower),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func updateRecordingPower() {
        let recordingPower = recordingController.getCurrentRecordingPower()
        uiLineChartView.data?.addEntry(
            ChartDataEntry(x: Double(xIndex), y: Double(recordingPower)),
            dataSetIndex: 0
        )
        uiLineChartView.data?.addEntry(
            ChartDataEntry(x: Double(xIndex), y: Double(-1 * recordingPower)),
            dataSetIndex: 1
        )
        xIndex += 1

        uiLineChartView.notifyDataSetChanged()
        uiLineChartView.moveViewToX(Double(xIndex))
        uiLineChartView.xAxis.labelCount = 100
    }

    @objc func updateRecordingDuration() {
        let secondsElapsed = recordingController.getCurrentRecordingDuration()
        let seconds = secondsElapsed.truncatingRemainder(dividingBy: 60)
        let minutes = Int(secondsElapsed / 60)

        let secondsString = String(format: "%02d", Int(seconds))
        let minutesString = String(format: "%02d", minutes)

        uiTimeLabel.text = minutesString + ":" + secondsString
    }

    func startRecording() {
        recordingController.startRecording(recorderDelegate: self)
        startRecordingDurationTimer()
        startRecordingPowerTimer()
    }

    func refreshRecordings() {
        recordings = recordingController.getRecordings()
    }

    func stopRecording() {
        recordingDurationTimer.invalidate()
        recordingPowerTimer.invalidate()
        recordingController.stopRecording()
        setUpLineChart()
        updateRecordingDuration()
        uiTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = recordings[indexPath.row].lastPathComponent
        cell.textLabel?.textAlignment = .center
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            playbackController = try PlaybackController(recordingFileName: recordings[indexPath.row])
            playbackController.play()
        } catch {
            // TODO: Handle error
        }
    }
}
