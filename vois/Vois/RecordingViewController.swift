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

class RecordingViewController: UIViewController, AVAudioRecorderDelegate, ChartViewDelegate {

    var segment: SongSegment!
    var recordingFilePath: URL!
    var recordingController: RecordingController!
    var recordingCount = 0
    var recordingDurationTimer: Timer!
    var recordingPowerTimer: Timer!
    var xIndex: Int!

    @IBOutlet private var uiLineChartView: LineChartView!
    @IBOutlet private var uiRecordButton: UIButton!
    @IBOutlet private var uiTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLineChart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recordingFilePath = segment.generateRecordingUrl()!
        recordingController = RecordingController(recordingFilePath: recordingFilePath)
    }

    @IBAction private func onRecordButtonTap(_ sender: UIButton) {
        let recordButtonImageName = "Record Button.png"
        let stopButtonImageName = "Stop Button.png"
        if recordingController.recordingInProgress {
            stopRecording()
            showSaveModal()
            sender.setImage(UIImage(named: recordButtonImageName), for: .normal)
        } else {
            startRecording()
            sender.setImage(UIImage(named: stopButtonImageName), for: .normal)
        }
    }

    func showSaveModal() {
        let saveViewController: SaveViewController? =
            storyboard!.instantiateViewController(withIdentifier: "saveViewController") as? SaveViewController
        saveViewController!.delegate = self
        saveViewController!.filePath = recordingFilePath
        saveViewController!.segment = segment
        saveViewController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(saveViewController!, animated: true, completion: nil)
    }

    func setUpRecordingTimers() {
        recordingDurationTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.updateRecordingDuration),
            userInfo: nil,
            repeats: true
        )

        recordingPowerTimer = Timer.scheduledTimer(
            timeInterval: 0.016,
            target: self,
            selector: #selector(self.updateRecordingPower),
            userInfo: nil,
            repeats: true
        )
    }

    func invalidateRecordingTimers() {
        recordingDurationTimer.invalidate()
        recordingPowerTimer.invalidate()
    }

    @objc
     func updateRecordingPower() {
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

    @objc
     func updateRecordingDuration() {
        let secondsElapsed = recordingController.currentRecordingDuration
        let seconds = secondsElapsed.truncatingRemainder(dividingBy: 60)
        let minutes = Int(secondsElapsed / 60)

        let secondsString = String(format: "%02d", Int(seconds))
        let minutesString = String(format: "%02d", minutes)

        uiTimeLabel.text = minutesString + ":" + secondsString
    }

    func startRecording() {
        if !recordingController.startRecording(recorderDelegate: self) {
            displayErrorAlert(title: "Oops", message: "Could not start recording")
        }
        setUpRecordingTimers()
    }

    func stopRecording() {
        invalidateRecordingTimers()
        recordingController.stopRecording()
        clearTimerAndWaveform()
    }

    func clearTimerAndWaveform() {
        setUpLineChart()
        updateRecordingDuration()
    }

    func configureLineChartView() {
        uiLineChartView.legend.enabled = false

        uiLineChartView.xAxis.drawGridLinesEnabled = false
        uiLineChartView.xAxis.drawAxisLineEnabled = false
        uiLineChartView.xAxis.drawLabelsEnabled = false

        uiLineChartView.rightAxis.enabled = false
        uiLineChartView.rightAxis.axisMinimum = -100.0
        uiLineChartView.rightAxis.axisMaximum = 100.0

        uiLineChartView.leftAxis.enabled = false
        uiLineChartView.leftAxis.axisMinimum = -100.0
        uiLineChartView.leftAxis.axisMaximum = 100.0
    }

    func configureLineChartDataset() -> LineChartDataSet {
        let powerValues = [ChartDataEntry]()
        let powerData = LineChartDataSet(entries: powerValues, label: "")

        powerData.drawCirclesEnabled = false
        powerData.setColor(.blue)
        powerData.fill = Fill.fillWithColor(.blue)
        powerData.drawFilledEnabled = true
        powerData.drawValuesEnabled = false
        powerData.mode = .cubicBezier

        return powerData
    }

    func setUpLineChart() {
        uiLineChartView.delegate = self
        xIndex = 0

        let powerData = configureLineChartDataset()
        let powerDataNegative = configureLineChartDataset()
        let dataSet = LineChartData(dataSets: [powerData, powerDataNegative])
        uiLineChartView.data = dataSet

        configureLineChartView()
    }

    func displayErrorAlert(title: String, message: String) {
        let uiErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(uiErrorAlert, animated: true, completion: nil)
    }
}
