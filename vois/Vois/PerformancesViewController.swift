//
//  PerformanceViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 16/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class PerformancesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var performancesView: UITableView! {
        didSet {
            performancesView.delegate = self
            performancesView.dataSource = self
            performancesView.separatorStyle = .none
        }
    }

    private func configureSearchBar() {
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
    }

    var performances: Performances!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchBar()
        performances = PerformanceFilesDirectory.allPerformances
        performancesView.reloadData()
    }

    @IBAction func openMasterViewController(_ sender: UIBarButtonItem) {
        guard let displayModeBarButton = splitViewController?.displayModeButtonItem,
            let displayAction = displayModeBarButton.action else {
            return
        }
        if splitViewController?.isCollapsed ?? false {
            parent?.navigationController?.popViewController(animated: true)

        } else {
        UIApplication.shared.sendAction(displayAction, to: displayModeBarButton.target, from: nil, for: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performances.numOfPerformances
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = performancesView.dequeueReusableCell(withIdentifier: "PerformanceCell", for: indexPath)
        guard let performanceCell = cell as? PerformanceCell else {
            return cell
        }
        let performance = performances.getPerformances(at: indexPath.row)

        performanceCell.title?.text = performance.name

        if let performanceDate = performance.date {
            performanceCell.dateTime?.text = performanceDate.toString
        } else {
            performanceCell.dateTime?.text = ""
        }
        return performanceCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPerformance", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let performanceVC = segue.destination as? PerformanceViewController,
            let index = sender as? Int else {
            return
        }

        performanceVC.performance = performances.getPerformances(at: index)
    }
}

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}

extension PerformanceFilesDirectory {
    static var allPerformances: Performances {
        Performances( PerformanceFilesDirectory.fileNames.compactMap { fileName in
            guard let data = PerformanceFilesDirectory.loadFile(name: fileName) else {
                return nil
            }
            return Performance(json: data)
        })
    }
}
