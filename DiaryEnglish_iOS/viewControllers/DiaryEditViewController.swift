//
//  DiaryEditViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import Combine

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let containerViewController = self.parent as? DiaryContainerViewController {
            containerViewController.headerView.saveButton.isHidden = false
        }
        updateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardPublisher()
        setupLayout()
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
        textViews.forEach { $0.delegate = self }
        switch transitionType {
        case .edit:
            editHeaderView.isHidden = false
        case .register:
            editHeaderView.isHidden = true
        }
        
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
    }
    
    private func updateLayout() {
        if case .register = transitionType {
            textViews.forEach { $0.text = nil }
        }
    }
    
    func dairyDataSave(completionHandler: (() -> Void)? = nil) {
        showAlert(title: "保存しました。",
                  actions: [UIAlertAction(title: "OK",
                                          style: .default) { [weak self] _ in
            guard let self else { return }
            switch transitionType {
            case .edit:
                CoreDataUsecase.shard.update(requestDiaryData: requestDiaryData)
                navigationController?.popViewController(animated: true)
            case .register:
                let id = NSUUID().uuidString
                requestDiaryData.id = id
                CoreDataUsecase.shard.save(requestDiaryData: requestDiaryData)
                completionHandler?()
            }
        }])
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
}
