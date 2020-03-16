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
    var delegate: RecordingViewController?
    var filePath: URL?

    @IBOutlet weak var uiTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getRecordingDirectoryPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryPath = paths[0]
        return documentDirectoryPath
    }

    @IBAction func onDiscardButtonClick(_ sender: Any) {
        let fileManager = FileManager()

        do {
            try fileManager.removeItem(at: filePath!)
        } catch {
            // TODO
            print("Crashing at delete item")
        }

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        let newPath = getRecordingDirectoryPath().appendingPathComponent(uiTextField.text! + ".m4a")

        let fileManager = FileManager()

        do {
            try fileManager.moveItem(at: filePath!, to: newPath)
        } catch {
            // TODO
            print("Crashing at move item")
        }

        delegate?.refreshRecordings()
        delegate?.uiTableView.reloadData()
    }
}
