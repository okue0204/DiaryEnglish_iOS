//
//  DiaryListTableViewCell.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/09.
//

import UIKit

protocol DiaryListTableViewCellDelegate: AnyObject {
    func englishDiarySpeechButtonDidTap(cell: UITableViewCell)
    func wantToSaySpeechButtonDidTap(cell: UITableViewCell)
}

class DiaryListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var japaneseDiaryLabel: UILabel!
    @IBOutlet weak var englishDiaryLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var watToSayLabel: UILabel!
    @IBOutlet weak var situationStackView: UIStackView!
    @IBOutlet weak var wantToSayStackView: UIStackView!
    @IBOutlet weak var japaneseDiaryLabelCotainerView: UIView!
    @IBOutlet weak var englishDiaryLabelCotainerView: UIView!
    @IBOutlet weak var situationLabelContainerView: UIView!
    @IBOutlet weak var wantToSayLabelContainerView: UIView!
    @IBOutlet weak var playBackgroundView: UIView!
    @IBOutlet weak var wantToSayPlayBackgroundView: UIView!
    
    weak var delegate: DiaryListTableViewCellDelegate?
    
    private lazy var labelContainerViews: [UIView] = [
        japaneseDiaryLabelCotainerView,
        englishDiaryLabelCotainerView,
        situationLabelContainerView,
        wantToSayLabelContainerView
    ]
    
    var diary: Diary? {
        didSet {
            guard let diary else { return }
            setupLayout(diary: diary)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout(diary: Diary) {
        labelContainerViews.forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1.0
        }
        japaneseDiaryLabel.text = diary.japanese
        englishDiaryLabel.text = diary.english
        situationStackView.isHidden = diary.situation.isNullOrEmpty
        wantToSayStackView.isHidden = diary.wantToSay.isNullOrEmpty
        situationLabel.text = diary.situation
        watToSayLabel.text = diary.wantToSay
        playBackgroundView.layer.cornerRadius = playBackgroundView.bounds.height / 2
        wantToSayPlayBackgroundView.layer.cornerRadius = wantToSayPlayBackgroundView.bounds.height / 2
    }
    
    @IBAction func englishDiarySpeechButtonDidTap(_ sender: Any) {
        delegate?.englishDiarySpeechButtonDidTap(cell: self)
    }
    
    @IBAction func wantToSaySpeechButtonDidTap(_ sender: Any) {
        delegate?.wantToSaySpeechButtonDidTap(cell: self)
    }
}
