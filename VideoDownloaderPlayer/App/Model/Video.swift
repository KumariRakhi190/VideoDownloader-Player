//
//  Video.swift
//  VideoDownloaderPlayer
//
//  Created by Rakhi Kumari on 27/04/25.
//

import Foundation
import Combine

class Video {
    
    let url: URL
    @Published var progress: Float?
    @Published var isDownloaded: Bool = false
    @Published var downloadedUrl: URL?
    @Published var isDownloading: Bool = false
    @Published var error: Error?
    
    init(url: URL) {
        self.url = url
    }
    
}

struct DownloadedVideo: Codable{
    let remoteUrl: URL?
    let downloadedUrl: URL?
}

extension UserDefaults{
    var downloadedVideos: [DownloadedVideo]? {
        get{
            try? JSONDecoder().decode([DownloadedVideo].self, from: data(forKey: "downloadedVideos") ?? Data())
        }
        set{
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue ?? []), forKey: "downloadedVideos")
        }
    }
    
}
