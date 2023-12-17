//
//  DiaryListViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import AVFoundation
import SwiftyDI
import Combine

class DiaryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: PaddingTextField! {
        didSet {
            searchTextField.layer.borderColor = UIColor.lightGray.cgColor
            searchTextField.layer.borderWidth = 1
            searchTextField.layer.cornerRadius = 10
        }
    }
    
    @Injected
    private var userDefaultsUsecase: UserDefaultUsecase
    
    private var disPoseBag = Set<AnyCancellable>()
    private var diaries: [Diary] = []
    private var speakingIndexPath: IndexPath?
    var speedData: Float?
    var pitchData: Float?
    
    let speecher = Speecher.shard
    let audioSession = AVAudioSession.sharedInstance()
    
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
        speecher.speechSynthesizer.delegate = self
        setupLayout()
        setupPublisher()
        checkHeadphonesConnected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let containerViewController = self.parent as? DiaryContainerViewController {
            containerViewController.headerView.saveButton.isHidden = true
        }
        fetchDiaryData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func setupPublisher() {
        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification, object: nil)
            .sink { [weak self] notification in
                guard let userInfo = notification.userInfo,
                      let routeChangeReasonRawValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                      let routeChangeReason = AVAudioSession.RouteChangeReason(rawValue: routeChangeReasonRawValue),
                      let self else {
                    return
                }

                switch routeChangeReason {
                case .newDeviceAvailable:
                    // イヤホン接続
                    do {
                        try audioSession.setCategory(.ambient, options: [])
                    } catch {
                        print(error.localizedDescription)
                    }
                case .oldDeviceUnavailable:
                    // イヤホン接続解除
                    do {
                        try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
                    } catch {
                        print(error.localizedDescription)
                    }
                default:
                    break
                }
            }.store(in: &disPoseBag)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                      let self else {
                    return
                }
                switch notification.name {
                case UIResponder.keyboardWillShowNotification:
                    guard let speakingIndexPath else {
                        return
                    }
                    tableView.scrollToRow(at: speakingIndexPath, at: .top, animated: true)
                case UIResponder.keyboardWillHideNotification:
                    tableView.contentInset.bottom = 0
                default:
                    break
                }
                
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseIn) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }.store(in: &disPoseBag)
    }
    
    private func checkHeadphonesConnected() {
        audioSession.currentRoute.outputs.forEach {
            if $0.portType == .headphones || $0.portType == .bluetoothA2DP || $0.portType == .bluetoothHFP || $0.portType == .bluetoothLE {
                try! audioSession.setCategory(.ambient, options: [])
            } else {
                try! audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            }
        }
    }
    
    private func fetchDiaryData() {
        diaries = CoreDataUsecase.shard.fetchData()
        tableView.reloadData()
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
        if let cell = tableView.cellForRow(at: indexPath) as? DiaryListTableViewCell {
            if cell.speakingTextView.isFirstResponder {
                cell.speakingTextView.resignFirstResponder()
            } else {
                if filteredDiaries.isEmpty {
                    return
                } else {
                    let diaryEditViewController = UIStoryboard.diaryEditViewControllerStoryboard.instantiateInitialViewController() as! DiaryEditViewController
                    diaryEditViewController.diary = filteredDiaries[indexPath.row]
                    diaryEditViewController.transitionType = .edit
                    navigationController?.pushViewController(diaryEditViewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = diaries[indexPath.row].id else {
                return
            }
            diaries.remove(at: indexPath.row)
            CoreDataUsecase.shard.delete(id: id)
            tableView.reloadData()
        }
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDiaries.isEmpty {
            return 1
        } else {
            return filteredDiaries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredDiaries.isEmpty {
            let cell = tableView.dequeueReusableCell(tableViewCell: NoDataTableViewCell.self, indexPath: indexPath) as! NoDataTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(tableViewCell: DiaryListTableViewCell.self, indexPath: indexPath) as! DiaryListTableViewCell
            cell.diary = filteredDiaries[indexPath.row]
            cell.isShowSpeakingTextView = false
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
            speecher.speech(voiceText: englishText,
                            speed: userDefaultsUsecase.isSpeedChange ? userDefaultsUsecase.speed : speecher.defaultSpeedValue,
                            pitch: userDefaultsUsecase.isPitchChange ? userDefaultsUsecase.pitch : speecher.defaultPitchValue)
        }
    }
    
    func wantToSaySpeechButtonDidTap(cell: UITableViewCell) {
        if let diaryListTableViewCell = cell as? DiaryListTableViewCell,
           let watToSayText = diaryListTableViewCell.watToSayLabel.text {
            speecher.speech(voiceText: watToSayText,
                            speed: userDefaultsUsecase.isSpeedChange ? userDefaultsUsecase.speed : speecher.defaultSpeedValue,
                            pitch: userDefaultsUsecase.isPitchChange ? userDefaultsUsecase.pitch : speecher.defaultPitchValue)
        }
    }
    
    func speakingButtonDidTap(event: UIEvent) {
        if let touch = event.allTouches?.first {
            let point = touch.location(in: tableView)
            if let speakingIndexPath = tableView.indexPathForRow(at: point) {
                self.speakingIndexPath = speakingIndexPath
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension DiaryListViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        do {
            try audioSession.setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }
}

fileprivate extension Array where Element == Diary {
    func filter(searchWord: String) -> [Diary] {
        return filter {
            guard let english = $0.english,
                  let japanese = $0.japanese,
                  let situation = $0.situation,
                  let wantToSay = $0.wantToSay else {
                return false
            }
            return english.contains(searchWord) || japanese.contains(searchWord) || situation.contains(searchWord) || wantToSay.contains(searchWord)
        }
    }
}

