//
//  CoreDataUsecase.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/28.
//

import Foundation

class CoreDataUsecase {
    
    private let coreDataRepository = CoreDataRepository.shared
    
    static let shard = CoreDataUsecase()
    private init() {}
    
    func save(requestDiaryData: RequestDiaryData) {
        let diary: Diary = coreDataRepository.createEntity()
        diary.id = requestDiaryData.id
        diary.japanese = requestDiaryData.japanese
        diary.english = requestDiaryData.english
        diary.situation = requestDiaryData.situation
        diary.wantToSay = requestDiaryData.wantToSay
        coreDataRepository.save(entity: diary)
    }
    
    func update(requestDiaryData: RequestDiaryData) {
        coreDataRepository.updateContext(requestDiaryData: requestDiaryData)
    }
    
    func fetchData() -> [Diary] {
        return coreDataRepository.fetchEntities()
    }
    
    func delete(id: String) {
        coreDataRepository.deleteEntities(id: id)
    }
}
