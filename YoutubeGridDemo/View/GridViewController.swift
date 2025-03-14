//
//  GridViewController.swift
//  YoutubeGridDemo
//
//  Created by Huei-Der Huang on 2025/3/13.
//

import UIKit
import Combine

class GridViewController: UIViewController {
    var viewModel = GridViewControllerViewModel()
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCombine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancellables.removeAll()
    }
    
    private func initUI() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Youtube searching.."
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewLayout = CollectionViewLayoutManager.CreateCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func onSearchButtonClick() {
        guard let text = searchBar.text, !text.isEmpty else { return }
        performSearch(query: text)
    }
    
    private func setupCombine() {
        viewModel.gridItemsSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in self.handleReloadData() }
            .store(in: &cancellables)
    }
    
    private func handleReloadData() {
        collectionView.reloadData()
    }
    
    private func performSearch(query: String) {
        Task {
            do {
                try await viewModel.search(query: query)
                performPlayVideo()
            } catch {
                showAlert(error: error)
            }
        }
    }
    
    private func showAlert(error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    private func performPlayVideo() {
        DispatchQueue.main.async {
            let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
            for indexPath in visibleIndexPaths {
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? GridCollectionViewCell else { continue }
                if indexPath.item % 10 == 0 || indexPath.item % 10 == 9 {
                    cell.play()
                } else {
                    cell.pause()
                }
            }
        }
    }
}

extension GridViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        viewModel.gridItemsSubject.value.removeAll()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else { return }
        performSearch(query: text)
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gridItemsSubject.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as! GridCollectionViewCell
        let item = viewModel.gridItemsSubject.value[indexPath.item]
        cell.configure(item: item)
        return cell
    }
}

extension GridViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        performPlayVideo()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? GridCollectionViewCell else { return }
        cell.pause()
    }
}
