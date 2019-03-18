//
//  SearchTableViewController.swift
//  CTwitter
//
//  Created by Djivede on 2019-03-17.
//  Copyright © 2019 spectrumdt. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTableViewController: TWTRTimelineViewController {
	fileprivate let viewModel = SearchTableViewModel()
	let searchController = UISearchController(searchResultsController: nil)

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
}

fileprivate extension SearchTableViewController {
	func configure() {
		self.showTweetActions = true
		self.dataSource = viewModel.generateDataSource(query: nil)
		configureSearchController()
	}
	
	func configureSearchController() {
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
		navigationItem.searchController = searchController
		definesPresentationContext = true
		searchController.searchBar.delegate = self
	}
}

extension SearchTableViewController: UISearchBarDelegate {
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		self.dataSource = viewModel.generateDataSource(query: searchBar.text)
	}
}
