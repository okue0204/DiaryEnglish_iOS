//
//  UITableView+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/09.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(tableViewCell: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: tableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: tableViewCell.self))
    }
    
    func dequeueReusableCell(tableViewCell: UITableViewCell.Type, indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: String(describing: tableViewCell.self), for: indexPath)
    }
}
