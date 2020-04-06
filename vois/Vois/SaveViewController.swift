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

    var performanceName: String!
    var songName: String!
    weak var delegate: RecordingViewController?
    var recordingController: RecordingController!
    var filePath: URL?
    let defaultErrorMessage = "Something went wrong. Please try again"

    @IBOutlet private var uiTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        recordingController = delegate?.recordingController
    }

    func displayErrorAlert(title: String, message: String) {
        let uiErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(uiErrorAlert, animated: true, completion: nil)
    }

    func getNewFileName() -> String {
        let newFileName = recordingController!.getTrimmedName(fileName: uiTextField.text!) + ".m4a"

        return newFileName
    }

    @IBAction private func onDiscardButtonClick(_ sender: Any) {
        let discardedRecordingSuccessfully = recordingController!.discardRecording()

        if discardedRecordingSuccessfully {
            self.dismiss(animated: true, completion: nil)
        } else {
            displayErrorAlert(title: "Oops", message: defaultErrorMessage)
        }
    }

    @IBAction private func onSaveButtonClick(_ sender: Any) {
        let newFilePath = getNewFilePath()
        let renamedRecordingSuccessfully = recordingController!.renameRecording(atPath: filePath!, toPath: newFilePath)
        let firebaseStorageAdapter = FirebaseStorageAdapter()

        guard let userName = UserSession.currentUserName else {
            return
        }

        if !renamedRecordingSuccessfully {
            return
        }

        do {
            let cloudFileName = userName + "_" + uiTextField.text!
            firebaseStorageAdapter.uploadFile(from: newFilePath, to: "recordings/" + cloudFileName)
            try PerformanceFilesDirectory
                .saveRecording(for: userName, performanceName: performanceName,
                               songName: songName, segmentName: getNewFileName())
            self.dismiss(animated: true, completion: nil)
            delegate?.refreshRecordings()
            delegate?.reloadTableData()
        } catch {
            displayErrorAlert(title: "Oops", message: defaultErrorMessage)
        }
    }

}
