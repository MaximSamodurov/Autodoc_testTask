//
//  ViewController.swift
//  Autodoc_testTask
//
//  Created by Fixed on 29.11.24.
//

import UIKit
import Combine

protocol NewsFeedDidRequestNavigation: AnyObject {
    func openDetailsScreen(for item: String)
}

class NewsFeedViewController: UIViewController, UICollectionViewDelegate {

    private var viewModel: NewsFeedViewModel
    private var dataSource: NewsFeedDataSource?
    private var cellViewModels = [NewsCellViewModel]()
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView! = nil
    
    weak var detailsRequestDelegate: NewsFeedDidRequestNavigation?
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        bindViewModel()
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.itemHeight))
            
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = LayoutConstants.groupInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = LayoutConstants.interGroupSpacing
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.footerHeight))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsFeedCell.self,
                                forCellWithReuseIdentifier: NewsFeedCell.reuseIdentifier)
        collectionView.register(LoadingFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingFooterView.reuseIdentifier)
        collectionView.dataSource = dataSource
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = NewsFeedDataSource(collectionView: collectionView) { collectionView, indexPath, cellViewModel in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewsFeedCell.reuseIdentifier,
                for: indexPath) as? NewsFeedCell
            
            let viewModel = self.cellViewModels[indexPath.item]
            cell?.configure(with: viewModel)
            
            return cell
        }
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LoadingFooterView.reuseIdentifier,
                    for: indexPath) as? LoadingFooterView
                return footer
            }
            return nil
        }
    }

    private func updateFooterVisibility(isLoading: Bool) {
        let footerIndexPath = IndexPath(item: 0, section: 0)
        guard let footer = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: footerIndexPath
        ) as? LoadingFooterView else { return }
        
        isLoading ? footer.startAnimating() : footer.stopAnimating()
    }
    
    private func bindViewModel() {
        viewModel.$newsCellViewModel.receive(on: DispatchQueue.main).sink { [weak self] viewModel in
            guard let self = self else { return }
            self.cellViewModels = viewModel
            applySnapshot(with: self.cellViewModels)
        }.store(in: &cancellables)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            guard let isLoading = isLoading else { return }
            guard let self = self else { return }
            isLoading && self.cellViewModels.isEmpty ? self.view.activityStartAnimating() : self.view.activityStopAnimating()
            
            guard !self.cellViewModels.isEmpty else { return }
            self.updateFooterVisibility(isLoading: true)
        }
        .store(in: &cancellables)
        
        viewModel.$erorrAlert.receive(on: DispatchQueue.main).sink { error in
            if error != nil {
                self.showAlert(title:
                                "Whoops, looks like something went wrong",
                               message: "\(error?.localizedDescription ?? "")")
            }
        }.store(in: &cancellables)
    }
    
    private func applySnapshot(with items: [NewsCellViewModel]) {
        var snapshot = NewsFeedSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }
}

extension NewsFeedViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == cellViewModels.count - 1 {
            viewModel.loadData()
        }
    }
}

extension NewsFeedViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        detailsRequestDelegate?.openDetailsScreen(for: item.fullURL)
    }
}

extension NewsFeedViewController {
        func showAlert(title: String, message: String, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
}



