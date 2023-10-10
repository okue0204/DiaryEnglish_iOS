//
//  DiaryListTableViewCell.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/09.
//

import UIKit

class DiaryListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var japaneseDiaryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        
    }
    
}
