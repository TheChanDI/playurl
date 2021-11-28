//
//  LocalVideoService.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 11/28/21.
//

import Foundation
import RealmSwift

class LocalVideoService {
    //MARK: Properties
    
    static let shared = LocalVideoService()
    
    let realm = try! Realm()
    
    
    //MARK: Read data
    func readData() -> Results<VideoModel>{
        return realm.objects(VideoModel.self)
    }
    
    
    //MARK: Delete data
    func deleteData(id: String) {
        
        readData().forEach({ (object) in
            if object.videoId == id {
                try! realm.write{
                    realm.delete(object)
                }
            }

        })
    }
    
    //MARK: Add data
     func writeData(id: String, name: String) {
        if readData().isEmpty {
            let dataToAdd = VideoModel()
            dataToAdd.videoId = id
            dataToAdd.videoName = name
            
            try! realm.write {
                realm.add(dataToAdd)
            }
        }
        else {
            if !readData().contains(where: { object in
                return object.videoId == id
            }) {
                let dataToAdd = VideoModel()
                dataToAdd.videoId = id
                dataToAdd.videoName = name
                
                try! realm.write {
                    realm.add(dataToAdd)
                }
            }
        }
    }
    
}
