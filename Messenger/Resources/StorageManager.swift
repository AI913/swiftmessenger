//
//  StorageManager.swift
//  Messenger
//
//  Created by 招耀華 on 24/9/2020.
//  Copyright © 2020 招耀華. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/dywchiu913-hotmail-com_profile_picture.png
     */
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion:  { metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedTopUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("failed to get downlaod url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    public enum StorageErrors: Error {
        case failedTopUpload
        case failedToGetDownloadUrl
    }
}
