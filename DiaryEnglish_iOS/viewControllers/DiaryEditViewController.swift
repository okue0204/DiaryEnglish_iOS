//
//  DiaryEditViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import Combine
import GoogleMobileAds

protocol DiaryEditViewControllerDelegate: AnyObject {
    func didDiaryUpdate()
}

class DiaryEditViewController: UIViewController {
    
    enum TransitionType {
        case edit
        case register
    }

    @IBOutlet weak var editHeaderView: UIView!
    @IBOutlet weak var japaneseTextView: UITextView!
    @IBOutlet weak var englishTextView: UITextView!
    @IBOutlet weak var situationTextView: UITextView!
    @IBOutlet weak var wantToSayTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    weak var delegate: DiaryEditViewControllerDelegate?
    
    lazy var textViews: [UITextView] = [
        japaneseTextView,
        englishTextView,
        situationTextView,
        wantToSayTextView
    ]
    
    var transitionType: TransitionType = .edit
    var cancellable = Set<AnyCancellable>()
    var requestDiaryData = RequestDiaryData()
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardPublisher()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let containerViewController = self.parent as? DiaryContainerViewController {
            containerViewController.headerView.saveButton.isHidden = false
        }
        updateLayout()
    }
    
    private func setupKeyboardPublisher() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                      let self else {
                    return
                }
                switch notification.name {
                case UIResponder.keyboardWillShowNotification:
                    scrollView.contentInset.bottom = keyboardSize.height
                case UIResponder.keyboardWillHideNotification:
                    scrollView.contentInset.bottom = 0
                default:
                    break
                }
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseIn) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }.store(in: &cancellable)
    }
    
    private func setupLayout() {
        bannerView.delegate = self
        bannerView.adUnitID = AppDelegate.advertisementUnitId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        if let diary {
            japaneseTextView.text = diary.japanese
            englishTextView.text = diary.english
            situationTextView.text = diary.situation
            wantToSayTextView.text = diary.wantToSay
            
            if let japanese = diary.japanese,
               let english = diary.english,
               let situation = diary.situation,
               let wantToSay = diary.wantToSay,
               let id = diary.id {
                requestDiaryData.japanese = japanese
                requestDiaryData.english = english
                requestDiaryData.situation = situation
                requestDiaryData.wantToSay = wantToSay
                requestDiaryData.id = id
            }
        } else {
            textViews.forEach { $0.text = nil }
        }
        
        let toolBar = UIToolbar()
        let okButton = UIBarButtonItem(title: "完了",
                                       style: .done,
                                       target: self,
                                       action: #selector(okButtonDidTap(_:)))
        let cancellButton = UIBarButtonItem(title: "キャンセル",
                                       style: .done,
                                       target: self,
                                            action: #selector(cancellButtonDidTap(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        toolBar.setItems([cancellButton, space, okButton], animated: true)
        toolBar.sizeToFit()
        textViews.forEach { $0.inputAccessoryView = toolBar }
        
        textViews.forEach { $0.delegate = self }
        switch transitionType {
        case .edit:
            editHeaderView.isHidden = false
        case .register:
            editHeaderView.isHidden = true
        }
        
        textViews.forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1.0
            $0.backgroundColor = .white
        }
    }
    
    private func updateLayout() {
        if case .register = transitionType {
            textViews.forEach { $0.text = nil }
            setupPlaceHolder(textViews: textViews)
        } else {
            let filteredTextViews = textViews.filter {
                $0.text.isEmpty
            }
            setupPlaceHolder(textViews: filteredTextViews)
        }
    }
    
    private func setupPlaceHolder(textViews: [UITextView]) {
        textViews.forEach {
            let placeHolderLabel: UILabel = {
                let label = UILabel()
                label.textColor = .lightGray
                label.numberOfLines = 0
                label.font = .systemFont(ofSize: 14)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            $0.addSubview(placeHolderLabel)
            $0.topAnchor.constraint(equalTo: placeHolderLabel.topAnchor, constant: -10).isActive = true
            $0.leadingAnchor.constraint(equalTo: placeHolderLabel.leadingAnchor, constant: -8).isActive = true
            
            switch $0 {
            case japaneseTextView:
                japaneseTextView.alpha = japaneseTextView.text.isEmpty ? 1 : 0
                placeHolderLabel.text = "日記又は覚えたいフレーズを記入しよう！"
            case englishTextView:
                englishTextView.alpha = englishTextView.text.isEmpty ? 1 : 0
                placeHolderLabel.text = "日本語日記を英語に変換してみよう！"
            case situationTextView:
                situationTextView.alpha = situationTextView.text.isEmpty ? 1 : 0
                placeHolderLabel.text = "言葉が出なかったのはどんなシチュエーションだった？"
            case wantToSayTextView:
                wantToSayTextView.alpha = wantToSayTextView.text.isEmpty ? 1 : 0
                placeHolderLabel.text = "絶対覚えたい１文を記入しよう！"
            default:
                break
            }
        }
    }
    
    private func displayPlaceHodler(textView: UITextView, updateText: String) {
        textView.subviews.forEach {
            if let label = $0 as? UILabel {
                if updateText.isEmpty {
                    label.alpha = 1
                } else {
                    label.alpha = 0
                }
            }
        }
    }
    
    func dairyDataSave() {
        let diarySaveAlertViewController = UIStoryboard.diayrSaveAlertStroyboard.instantiateInitialViewController() as! DiarySaveAlertViewController
        diarySaveAlertViewController.modalTransitionStyle = .crossDissolve
        diarySaveAlertViewController.modalPresentationStyle = .overCurrentContext
        diarySaveAlertViewController.delegate = self
        if japaneseTextView.text.isEmpty, englishTextView.text.isEmpty {
            diarySaveAlertViewController.transition = .alert
        } else {
            diarySaveAlertViewController.transition = .save
        }
        present(diarySaveAlertViewController, animated: true)
    }
    
    @objc
    private func okButtonDidTap(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @objc
    private func cancellButtonDidTap(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        dairyDataSave()
    }
}

extension DiaryEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case japaneseTextView:
            requestDiaryData.japanese = textView.text
        case englishTextView:
            requestDiaryData.english = textView.text
        case situationTextView:
            requestDiaryData.situation = textView.text
        case wantToSayTextView:
            requestDiaryData.wantToSay = textView.text
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let inputText = textView.text,
           let range = Range(range, in: inputText) {
            let updateText = inputText.replacingCharacters(in: range, with: text)
            switch textView {
            case japaneseTextView:
                displayPlaceHodler(textView: japaneseTextView, updateText: updateText)
            case englishTextView:
                displayPlaceHodler(textView: englishTextView, updateText: updateText)
            case situationTextView:
                displayPlaceHodler(textView: situationTextView, updateText: updateText)
            case wantToSayTextView:
                displayPlaceHodler(textView: wantToSayTextView, updateText: updateText)
            default:
                break
            }
        }
        return true
    }
}

extension DiaryEditViewController: DiarySaveAlertViewControllerDelegate {
    func didAletClose() {
        switch transitionType {
        case .edit:
            CoreDataUsecase.shard.update(requestDiaryData: requestDiaryData)
            navigationController?.popViewController(animated: true)
        case .register:
            let id = NSUUID().uuidString
            requestDiaryData.id = id
            CoreDataUsecase.shard.save(requestDiaryData: requestDiaryData)
            delegate?.didDiaryUpdate()
        }
    }
}

extension DiaryEditViewController: GADBannerViewDelegate {
    
}
