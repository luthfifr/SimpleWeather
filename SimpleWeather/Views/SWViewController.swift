//
//  SWViewController.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Toast_Swift

class SWViewController: UIViewController {
    typealias Cell = SWViewControllerCollectionViewCell

    private let disposeBag = DisposeBag()

    private var viewModel: SWViewControllerViewModel!
    private var dataModel: SWWeatherDataModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    private var collectionView: UICollectionView!
    private var loadingView: SWLoadingView!
    private let refresher = UIRefreshControl()

    private let cellID = String(describing: Cell.self)
    private let cellPadding: CGFloat = 16

    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = SWViewControllerViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = SWViewControllerViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Current Weather"

        viewModel.viewModelEvents.onNext(.getData)

        setupUI()
        showHideLoadingView(true)
        setupEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private methods
extension SWViewController {
    private func setupEvents() {
        viewModel
            .uiEvents
            .subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }

            self.showHideLoadingView(false)

            switch event {
            case .getDataSuccess:
                self.dataModel = self.viewModel.responseModel
                if !self.viewModel.isOnline {
                    self.showToast(with: "Offline Mode")
                }
            case .getDataFailure(let error):
                self.showError(error)
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func setupUI() {
        setupCollectionView()
        setupLoadingView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(Cell.self, forCellWithReuseIdentifier: cellID)

        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                       attributes: [NSAttributedString.Key.font: UIFont(name: "GillSans", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)]) //swiftlint:disable:this line_length
        refresher.addTarget(self,
                            action: #selector(reloadCollectionView),
                            for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresher
        } else {
            collectionView.addSubview(refresher)
        }

        if !view.subviews.contains(collectionView) {
            view.addSubview(collectionView)
        }

        collectionView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }

    private func setupLoadingView() {
        if loadingView == nil {
            loadingView = SWLoadingView(frame: .zero)
            loadingView.titleText = "Loading..."

            if !view.subviews.contains(loadingView) {
                view.addSubview(loadingView)
            }

            loadingView.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
    }

    @objc private func reloadCollectionView() {
        if #available(iOS 10.0, *) {
            guard let refreshCtrl = collectionView.refreshControl else { return }
            refreshCtrl.beginRefreshing()
            showHideLoadingView(true)
            viewModel.viewModelEvents.onNext(.getData)
            refreshCtrl.endRefreshing()
        } else {
            refresher.beginRefreshing()
            showHideLoadingView(true)
            viewModel.viewModelEvents.onNext(.getData)
            refresher.endRefreshing()
        }
    }

    private func showHideLoadingView(_ isShown: Bool) {
        loadingView.animateSpinning(isShown)
        if isShown {
            view.bringSubviewToFront(loadingView)
        } else {
            view.sendSubviewToBack(loadingView)
        }

        loadingView.isHidden = !isShown
    }

    private func setupToast() {
        let toastManager = ToastManager.shared
        toastManager.position = .bottom
        toastManager.duration = 1
    }

    private func showToast(with message: String) {
        view.makeToast(message)
    }

    private func showError(_ error: SWServiceError?) {
        var alertModel = UIAlertModel(style: .alert)
        guard let error = error else {
            return
        }
        alertModel.message = error.responseString ?? String()
        alertModel.title = "Request Data Failure"
        alertModel.actions = [UIAlertActionModel(title: "OK", style: .cancel)]
        self.showAlert(with: alertModel)
            .asObservable()
            .subscribe(onNext: { selectedActionIdx in
                #if DEBUG
                print("alert action index = \(selectedActionIdx)")
                #endif
            }).disposed(by: self.disposeBag)
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

// MARK: - UICollectionViewDelegate
extension SWViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.setData(with: self.dataModel)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SWViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = view.frame.width
        return CGSize(width: frameWidth, height: frameWidth*1.8)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellPadding, left: 0, bottom: cellPadding, right: 0)
    }
}
