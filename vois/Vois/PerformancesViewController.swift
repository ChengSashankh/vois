//
//  PerformanceViewController.swift
//  Vois
//
//  Created by Jiang Yuxin on 16/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class PerformancesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var filteredTableData = [Performance]()
    var searching = false

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var subtitle: UILabel!

    @IBOutlet weak var performancesView: UITableView! {
        didSet {
            performancesView.delegate = self
            performancesView.dataSource = self
            performancesView.separatorStyle = .none
        }
    }

//    var isSearchBarEmpty: Bool {
//      return searchController.searchBar.text?.isEmpty ?? true
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = performances.getPerformances().filter { $0.name.lowercased().contains(searchText.lowercased()) }
        searching = true
        performancesView.reloadData()
        print (filteredTableData)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredTableData = performances.getPerformances().filter { (performance: Performance) -> Bool in
            return performance.name.lowercased().contains(searchText.lowercased())
        }

        performancesView.reloadData()
    }

    private func configureSearchBar() {
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
    }

//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = self.searchBar!
//        filterContentForSearchText(searchBar.text!)
//    }

    var performances: Performances!
//    let searchController = UISearchController(searchResultsController: nil)

    private func configureSubtitle() {
        subtitle.text = "\(performances.numOfPerformances) performances"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Hello world"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchBar()
        let user = UserSession.user
        performances = user?.performances ?? Performances()
        performancesView.reloadData()
        configureSubtitle()
    }

    @IBAction func onCancelButtonClick(_ sender: Any) {
        searching = false
        searchBar.endEditing(true)
        performancesView.reloadData()
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
        if searching {
            return filteredTableData.count
        } else {
            return performances.numOfPerformances
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = performancesView.dequeueReusableCell(withIdentifier: "PerformanceCell", for: indexPath)
        guard let performanceCell = cell as? PerformanceCell else {
            return cell
        }

        var performance = performances.getPerformances(at: indexPath.row)

        if searching {
            performance = filteredTableData[indexPath.row]
        }

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
            configureSubtitle()
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
