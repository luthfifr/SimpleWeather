//
//  SWViewControllerCollectionViewCell.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import SnapKit

class SWViewControllerCollectionViewCell: UICollectionViewCell {
    typealias SingleImageCell = SWViewControllerTableViewCell
    typealias DefaultCell = UITableViewCell

    private var containerView: UIView!
    private var roundedCornerView: UIView!
    private var tableView: UITableView!

    private let defaultCellID = String(describing: DefaultCell.self)
    private let singleImgCellID = String(describing: SingleImageCell.self)

    private var dataModel: SWWeatherDataModel? {
        didSet {
            tableView.reloadData()
        }
    }
    private var labelDataParamsDict = [Int: SWLabelDataParams]()
    private var smallIconNameDict = [Int: String]()

    // MARK: - Initialization
    convenience init() {
        self.init()
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

// MARK: - Public methods
extension SWViewControllerCollectionViewCell {
    func setData(with data: SWWeatherDataModel?) {
        self.dataModel = data
        guard let data = data,
            let weatherData = data.weather?.first,
            let main = data.main,
            let wind = data.wind else { return }

        let gillSansSemiBold = UIFont(name: "GillSans-SemiBold", size: 12)

        labelDataParamsDict[0] = SWLabelDataParams(text: data.name ?? "City Name",
                                                   numberOfLines: 0,
                                                   textAlignment: .center,
                                                   font: UIFont(name: "Arial-BoldMT", size: 32))
        labelDataParamsDict[2] = SWLabelDataParams(text: weatherData.description ?? "No description",
                                                   numberOfLines: 0,
                                                   textAlignment: .center)
        labelDataParamsDict[3] = SWLabelDataParams(text: "\(main.humidity ?? -1)%",
            font: gillSansSemiBold)
        labelDataParamsDict[4] = SWLabelDataParams(text: "\(main.pressure ?? -1) hPa",
            font: gillSansSemiBold)
        labelDataParamsDict[5] = SWLabelDataParams(text: "\(wind.speed ?? 0) m/s",
            font: gillSansSemiBold)
        let celcius = (main.temp ?? 0) - Double(273.15)
        labelDataParamsDict[6] = SWLabelDataParams(text: "\(celcius.rounded()) °C",
            numberOfLines: 0,
            textAlignment: .center,
            font: UIFont(name: "Arial-BoldMT", size: 52))
        labelDataParamsDict[7] = SWLabelDataParams(text: data.requestTime ?? "NOW", numberOfLines: 0,
                                                   textAlignment: .center,
                                                   font: UIFont(name: "ArialMT", size: 22))

        smallIconNameDict[3] = "icon_waterDrop"
        smallIconNameDict[4] = "icon_gauge"
        smallIconNameDict[5] = "icon_flag"
    }
}

// MARK: - Private methods
extension SWViewControllerCollectionViewCell {
    private func setupViews() {
        setupContainerView()
        setupRoundedCornerView()
        setupTableView()
    }

    private func setupContainerView() {
        guard containerView == nil else { return }

        containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 10

        if !contentView.subviews.contains(containerView) {
            contentView.addSubview(containerView)
        }

        containerView.snp.makeConstraints({ make in
            make.leading
                .equalTo(contentView.snp.leading).offset(16)
            make.trailing
                .equalTo(contentView.snp.trailing).offset(-16)
            make.top
                .equalTo(contentView.snp.top).offset(16)
            make.bottom
                .equalTo(contentView.snp.bottom).offset(-16)
        })
    }

    private func setupRoundedCornerView() {
        guard roundedCornerView == nil else { return }
        roundedCornerView = UIView(frame: .zero)
        roundedCornerView.backgroundColor = .white
        roundedCornerView.layer.cornerRadius = 5
        roundedCornerView.layer.masksToBounds = true

        if !containerView.subviews.contains(roundedCornerView) {
            containerView.addSubview(roundedCornerView)
        }

        roundedCornerView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }

    private func setupTableView() {
        guard tableView == nil else { return }
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        tableView.register(SingleImageCell.self, forCellReuseIdentifier: singleImgCellID)

        if !roundedCornerView.subviews.contains(tableView) {
            roundedCornerView.addSubview(tableView)
        }

        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}

// MARK: - UITableViewDataSource
extension SWViewControllerCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return roundedCornerView.frame.height*0.2
        case 1:
            return roundedCornerView.frame.height*0.25
        case 6:
            return roundedCornerView.frame.height*0.1
        default:
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 1:
            guard let cell1 = tableView
                .dequeueReusableCell(withIdentifier: singleImgCellID,
                                                            for: indexPath) as? SingleImageCell else {
                return cell
            }
            cell = cell1
        default:
            let cellOthers = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath)
            cell = cellOthers
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension SWViewControllerCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let data = dataModel,
            let weatherData = data.weather?.first else { return }

        switch indexPath.row {
        case 1:
            guard let singelImgCell = cell as? SingleImageCell,
                let mainData = weatherData.main else {
                return
            }
            var imageName = String()
            switch mainData {
            case "Rain":
                imageName = "icon_rain"
            case "Clouds":
                imageName = "icon_cloud"
            default:
                imageName = "icon_sun"
            }
            singelImgCell.setImage(with: imageName)
        case 3, 4, 5:
            cell.imageView?.image = UIImage(named: smallIconNameDict[indexPath.row] ?? String())
            cell.imageView?.contentMode = .scaleAspectFit
        default:
            break
        }

        if indexPath.row != 1 {
            cell.textLabel?.assignData(with: labelDataParamsDict[indexPath.row] ?? SWLabelDataParams())
        }
    }
}
