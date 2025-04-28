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
    @Published var isPaused: Bool = false
    var downloader: VideoDownloader?
    
    init(url: URL) {
        self.url = url
    }
    
}

struct DownloadedVideo: Codable {
    let remoteUrl: URL?
    let downloadedUrl: URL?
}

extension UserDefaults {
    var downloadedVideos: [DownloadedVideo]? {
        get {
            guard let data = data(forKey: "downloadedVideos"),
                  var videos = try? JSONDecoder().decode([DownloadedVideo].self, from: data)
            else { return nil }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            // Update each downloadedUrl dynamically
            videos = videos.map { video in
                guard let lastPath = video.downloadedUrl?.lastPathComponent else {
                    return video
                }
                let updatedUrl = documentsDirectory?.appendingPathComponent(lastPath)
                return DownloadedVideo(remoteUrl: video.remoteUrl, downloadedUrl: updatedUrl)
            }
            
            return videos
        }
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue ?? []), forKey: "downloadedVideos")
        }
    }
}
