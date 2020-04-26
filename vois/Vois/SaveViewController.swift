//
//  SaveViewController.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 15.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import Foundation

class SaveViewController: UIViewController {

    var segment: SongSegment!
    var filePath: URL!
    weak var delegate: RecordingViewController?
    var recordingController: RecordingController!
    let defaultErrorMessage = "Something went wrong. Please try again"

    @IBOutlet private var uiTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        recordingController = delegate?.recordingController
        uiTextField.text = getDefaultAttemptFileName()
    }

    func getDefaultAttemptFileName() -> String {
        return "Attempt-" + getCurrentDateTimeString()
    }

    func getCurrentDateTimeString() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: date)
    }

    func displayErrorAlert(title: String, message: String) {
        let uiErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(uiErrorAlert, animated: true, completion: nil)
    }

    private func getTrimmedName() -> String {
        let trimmedString = uiTextField.text!
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
        return trimmedString
    }

    @IBAction private func onDiscardButtonClick(_ sender: Any) {
        let discardedRecordingSuccessfully = segment.removeRecording(at: filePath)

        if discardedRecordingSuccessfully {
            self.dismiss(animated: true, completion: nil)
        } else {
            displayErrorAlert(title: "Oops", message: defaultErrorMessage)
        }
    }

    @IBAction private func onSaveButtonClick(_ sender: Any) {
            segment.addRecording(recording: Recording(name: getTrimmedName(), filePath: filePath))
            self.dismiss(animated: true, completion: nil)
        delegate?.navigationController?.popViewController(animated: false)
    }

}
