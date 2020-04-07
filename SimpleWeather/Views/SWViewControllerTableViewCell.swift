//
//  SWViewControllerTableViewCell.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
import SnapKit

class SWViewControllerTableViewCell: UITableViewCell {

    private var imgView: UIImageView!

    // MARK: - Initialization
    convenience init() {
        self.init()
        setupImgView()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImgView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImgView()
    }

    private func setupImgView() {
        guard imgView == nil else { return }
        imgView = UIImageView(frame: .zero)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false

        if !contentView.subviews.contains(imgView) {
            contentView.addSubview(imgView)
        }

        imgView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }

    func setImage(with name: String) {
        imgView.image = UIImage(named: name)
    }
}
