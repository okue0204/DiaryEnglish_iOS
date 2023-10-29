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
    
    var diaries: [Diary] = []
    var speedData: Float?
    var pitchData: Float?
    
    let speecher = Speecher.shard
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let containerViewController = self.parent as? DiaryContainerViewController {
            containerViewController.headerView.saveButton.isHidden = true
        }
        fetchDiaryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
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
        if filteredDiaries.isEmpty {
            return
        } else {
            let diaryEditViewController = UIStoryboard.diaryEditViewControllerStoryboard.instantiateInitialViewController() as! DiaryEditViewController
            diaryEditViewController.diary = filteredDiaries[indexPath.row]
            diaryEditViewController.transitionType = .edit
            navigationController?.pushViewController(diaryEditViewController, animated: true)
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
