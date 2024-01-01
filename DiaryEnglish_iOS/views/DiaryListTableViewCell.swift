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
    func speakingButtonDidTap(event: UIEvent)
    func howToSpeakingButtonDidTap()
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
    @IBOutlet weak var howToSpeakingBackgroundView: UIView!
    @IBOutlet weak var wantToSayPlayBackgroundView: UIView!
    @IBOutlet weak var speakingStackView: UIStackView!
    @IBOutlet weak var speakingTextView: UITextView!
    @IBOutlet weak var speakingTextViewShowButton: UIButton!
    @IBOutlet weak var speakingButtonBackgroundView: UIView!
    @IBOutlet weak var speakingTextLabel: UILabel!
    
    weak var delegate: DiaryListTableViewCellDelegate?
    
    var textViewCallBack: ((UITextView) -> Void)?
    
    private lazy var labelContainerViews: [UIView] = [
        japaneseDiaryLabelCotainerView,
        englishDiaryLabelCotainerView,
        situationLabelContainerView,
        wantToSayLabelContainerView
    ]
    
    var isShowSpeakingTextView: Bool = false {
        didSet {
            speakingTextLabel.text = isShowSpeakingTextView ? "スピーキング練習用Textを閉じる" : "スピーキング練習用Textを表示する"
        }
    }
    
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
        textViewCallBack?(speakingTextView)
        labelContainerViews.forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1.0
        }
        japaneseDiaryLabel.text = diary.japanese
        englishDiaryLabel.text = diary.english
        speakingStackView.isHidden = true
        situationStackView.isHidden = diary.situation.isNullOrEmpty
        wantToSayStackView.isHidden = diary.wantToSay.isNullOrEmpty
        situationLabel.text = diary.situation
        watToSayLabel.text = diary.wantToSay
        playBackgroundView.layer.cornerRadius = playBackgroundView.bounds.height / 2
        wantToSayPlayBackgroundView.layer.cornerRadius = wantToSayPlayBackgroundView.bounds.height / 2
        howToSpeakingBackgroundView.layer.cornerRadius = howToSpeakingBackgroundView.bounds.height / 2
        speakingButtonBackgroundView.layer.cornerRadius = speakingButtonBackgroundView.bounds.height / 2
        speakingTextView.text = nil
        speakingTextView.layer.cornerRadius = 10
        speakingTextView.layer.borderColor = UIColor.lightGray.cgColor
        speakingTextView.layer.borderWidth = 1.0
        speakingTextView.backgroundColor = .white
        speakingTextView.textColor = .black
    }
    
    @IBAction func englishDiarySpeechButtonDidTap(_ sender: Any) {
        delegate?.englishDiarySpeechButtonDidTap(cell: self)
    }
    
    @IBAction func wantToSaySpeechButtonDidTap(_ sender: Any) {
        delegate?.wantToSaySpeechButtonDidTap(cell: self)
    }
    
    @IBAction func speakingButtonDidTap(_ sender: UIButton, event: UIEvent) {
        if speakingTextView.isFirstResponder {
            speakingTextView.resignFirstResponder()
        }
        isShowSpeakingTextView.toggle()
        speakingStackView.isHidden.toggle()
        delegate?.speakingButtonDidTap(event: event)
    }
    
    @IBAction func howToSpeakingButtonDidTap(_ sender: Any) {
        delegate?.howToSpeakingButtonDidTap()
    }
}
