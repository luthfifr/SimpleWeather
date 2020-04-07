//
//  SWViewController.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import SnapKit

class SWViewController: UIViewController {
    typealias Cell = SWViewControllerCollectionViewCell

    private var collectionView: UICollectionView!

    private let cellID = String(describing: Cell.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Current Weather"
    }
}

// MARK: - Private methods
extension SWViewController {
    private func setupUI() {
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: cellID)

        if !view.subviews.contains(collectionView) {
            view.addSubview(collectionView)
        }

        collectionView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}

// MARK: - UICollectionViewDataSource
extension SWViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.isUserInteractionEnabled = false
        return cell
    }
}

extension SWViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
    }
}
