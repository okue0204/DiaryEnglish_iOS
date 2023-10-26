//
//  DiaryListViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import AVFoundation
import SwiftyDI

class DiaryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchTextField: PaddingTextField!
    
    @Injected
    private var userDefaultsUsecase: UserDefaultUsecase
    
    var diaries: [Diary] = [
        Diary(japanese: "今日は胸トレをした。とても疲れた。明日は足トレをするよ。",
              english: "I did workout for chest so very tired, I`m going to work out for leg",
              situation: "同僚にジムの話をしている時",
              wantToSay: "I did workout for chest"),
        Diary(japanese: "えええ",
              english: "huuu",
              situation: "",
              wantToSay: ""),
        Diary(japanese: "ううう",
              english: "huuu",
              situation: "",
              wantToSay: ""),
        Diary(japanese: "いい",
              english: "huuu",
              situation: "",
              wantToSay: ""),
        Diary(japanese: "ああ",
              english: "v",
              situation: "",
              wantToSay: ""),
        Diary(japanese: "おお",
              english: "huuu",
              situation: "",
              wantToSay: ""),
        Diary(japanese: "かかか",
              english: "when I was riding",
              situation: "",
              wantToSay: ""),
    ]
    
    var speedData: Float?
    var pitchData: Float?
    
    var speechSynthesizer = AVSpeechSynthesizer()
    
    private var searchWord: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filteredDiaries: [Diary] {
        guard let searchWord, !searchWord.isEmpty else {
            return diaries
        }
        return diaries.filter(searchWord: searchWord)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.registerCell(tableViewCell: DiaryListTableViewCell.self)
        tableView.registerCell(tableViewCell: NoDataTableViewCell.self)
        searchTextField.delegate = self
        searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(string: "search", attributes: [.foregroundColor: UIColor.lightGray])
        createToolBar()
    }
    
    private func createToolBar() {
        let toolBar = UIToolbar()
        let cancellButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancellButtonDidTap(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.sizeToFit()
        toolBar.setItems([cancellButton, spacer], animated: true)
        searchTextField.inputAccessoryView = toolBar
    }
    
    private func setupSynthesizer(voiceText: String) {
        let utterance = AVSpeechUtterance.init(string: voiceText)
        if let speedData {
            utterance.rate = speedData
        }
        if let pitchData {
            utterance.pitchMultiplier = pitchData
        }
        utterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
    
    @objc private func cancellButtonDidTap(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        searchTextField.text = nil
        searchWord = nil
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredDiaries.isEmpty {
            return
        } else {
            let diaryEditViewController = UIStoryboard.diaryEditViewControllerStoryboard.instantiateInitialViewController() as! DiaryEditViewController
            diaryEditViewController.diary = diaries[indexPath.row]
            diaryEditViewController.transitionType = .edit
            navigationController?.pushViewController(diaryEditViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            diaries.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if diaries.isEmpty {
            return 1
        } else {
            return filteredDiaries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diaries.isEmpty {
            let cell = tableView.dequeueReusableCell(tableViewCell: NoDataTableViewCell.self, indexPath: indexPath) as! NoDataTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(tableViewCell: DiaryListTableViewCell.self, indexPath: indexPath) as! DiaryListTableViewCell
            cell.diary = filteredDiaries[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
}

extension DiaryListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchWord = textField.text
        }
        view.endEditing(true)
        return true
    }
}

extension DiaryListViewController: DiaryListTableViewCellDelegate {
    func englishDiarySpeechButtonDidTap(cell: UITableViewCell) {
        if let diaryListTableViewCell = cell as? DiaryListTableViewCell,
           let englishText = diaryListTableViewCell.englishDiaryLabel.text {
            setupSynthesizer(voiceText: englishText)
        }
    }
    
    func wantToSaySpeechButtonDidTap(cell: UITableViewCell) {
        if let diaryListTableViewCell = cell as? DiaryListTableViewCell,
           let watToSayText = diaryListTableViewCell.watToSayLabel.text {
            setupSynthesizer(voiceText: watToSayText)
        }
    }
}

extension DiaryListViewController: SettingViewControllerDelegate {
    func didVoiceSpeed(speedData: Float) {
        self.speedData = speedData
    }
    
    func didVoicePich(pitchData: Float) {
        self.pitchData = pitchData
        userDefaultsUsecase.pitch = pitchData
    }
}

fileprivate extension Array where Element == Diary {
    func filter(searchWord: String) -> [Diary] {
        return filter {
            if let situation = $0.situation, let wantToSay = $0.wantToSay {
                return $0.english.contains(searchWord) || $0.japanese.contains(searchWord) || situation.contains(searchWord) || wantToSay.contains(searchWord)
            } else {
                return $0.english.contains(searchWord) || $0.japanese.contains(searchWord)
            }
        }
    }
}
