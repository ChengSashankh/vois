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

    @IBOutlet weak var subtitle: UILabel!

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

    private func configureSubtitle() {
        subtitle.text = "\(performances.numOfPerformances) performances"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchBar()
        guard let username = UserSession.currentUsername, let userEmail = UserSession.currentUserEmail else {
            return
        }
        let user = User(username: username, email: userEmail)
        performances = user.performances ?? Performances()
        performancesView.reloadData()
        configureSubtitle()
    }

    @IBAction func openMasterViewController(_ sender: UIBarButtonItem) {
        guard let displayModeBarButton = splitViewController?.displayModeButtonItem,
            let displayAction = displayModeBarButton.action else {
            return
        }
        if splitViewController?.isCollapsed ?? false {
            if parent?.navigationController != nil {
                parent?.navigationController?.popViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }

        } else {
        UIApplication.shared.sendAction(displayAction, to: displayModeBarButton.target, from: nil, for: nil)
            splitViewController?.preferredDisplayMode = .primaryOverlay
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            performances.removePerformance(at: indexPath.row)
            performancesView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let performanceVC = segue.destination as? PerformanceViewController,
            let index = sender as? Int {
            performanceVC.performance = performances.getPerformances(at: index)
        }

        if let createPerformanceVC = segue.destination as? CreatePerformanceTableViewController {
            createPerformanceVC.performances = performances
        }


    }
}

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
