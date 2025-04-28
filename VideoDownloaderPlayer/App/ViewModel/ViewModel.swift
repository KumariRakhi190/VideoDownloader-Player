//
//  ViewModel.swift
//  VideoDownloaderPlayer
//
//  Created by Rakhi Kumari on 27/04/25.
//

import Foundation

class ViewModel {
            
    let videos: [Video] = [
        
        Video(url: URL(string: "https://player.vimeo.com/progressive_redirect/playback/433925279/rendition/1080p/file.mp4?loc=external&signature=50856478a378907bc656554b1de94f38a7704cc9206c9bff46a83cfb36f35e63")!),
        Video(url: URL(string: "https://player.vimeo.com/progressive_redirect/playback/433927495/rendition/360p/file.mp4?loc=external&signature=02578fff5efc682f5afde55867c62a496a6a654107831fded0b3b48c8bd8038c")!),
        Video(url: URL(string: "https://player.vimeo.com/progressive_redirect/playback/433664412/rendition/720p/file.mp4?loc=external&signature=c181e93e63d3979c0b9124f6a9dd98ea48c28d7d2598bedbe33f94663d6b16b6")!),
        Video(url: URL(string: "https://player.vimeo.com/progressive_redirect/playback/433937419/rendition/1080p/file.mp4?loc=external&signature=5e84d1bcbbd42caf7fab6e63e284b0383b2e4e02f5cd6d76f102670099a5ff94")!),
        Video(url: URL(string: "https://player.vimeo.com/progressive_redirect/playback/433947577/rendition/1080p/file.mp4?loc=external&signature=946c6b2133120806a0cbaeec334708dda1dd7bb6f399f2e6f14224a61bf164ca")!)
    ]
    
    

    
//    func downloadVideo(video: Video){
//        let videoDownloader = VideoDownloader()
//        videoDownloader.downloadVideo(from: video.url) { progress in
//            video.progress = progress
//            video.isDownloading = true
//        } onCompletion: { url in
//            video.downloadedUrl = url
//            video.isDownloaded = true
//            video.isDownloading = false
//            
//            var downloadedVideos = UserDefaults.standard.downloadedVideos ?? []
//            downloadedVideos.append(DownloadedVideo(remoteUrl: video.url, downloadedUrl: url))
//            UserDefaults.standard.downloadedVideos = downloadedVideos
//            
//        } onError: { error in
//            video.error = error
//        }
//        
//    }
    
    func downloadVideo(video: Video) {
        let videoDownloader = VideoDownloader()
        video.downloader = videoDownloader  // Store downloader inside the video
        
        videoDownloader.downloadVideo(from: video.url) { progress in
            video.progress = progress
            video.isDownloading = true
        } onCompletion: { url in
            video.downloadedUrl = url
            video.isDownloaded = true
            video.isDownloading = false
            video.downloader = nil   // ✅ Clear downloader after completion
            
            var downloadedVideos = UserDefaults.standard.downloadedVideos ?? []
            downloadedVideos.append(DownloadedVideo(remoteUrl: video.url, downloadedUrl: url))
            UserDefaults.standard.downloadedVideos = downloadedVideos
            
        } onError: { error in
            video.error = error
            video.isDownloading = false
            video.downloader = nil   // ✅ Clear downloader after error
        }
    }
    
    func pauseDownload(video: Video) {
        video.downloader?.pauseDownload()
        video.isPaused = true
    }

    func resumeDownload(video: Video) {
        video.downloader?.resumeDownload()
        video.isPaused = false
    }


    
}

