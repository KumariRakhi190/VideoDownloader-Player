//
//  VideoDownloader.swift
//  VideoDownloaderPlayer
//
//  Created by Rakhi Kumari on 27/04/25.
//


//import Foundation
//
//class VideoDownloader: NSObject, URLSessionDownloadDelegate {
//    
//    private var urlSession: URLSession!
//    
//    // Closures
//    private var onProgress: ((Float) -> Void)?
//    private var onCompletion: ((URL?) -> Void)?
//    private var onError: ((Error) -> Void)?
//    
//    override init() {
//        super.init()
//        let configuration = URLSessionConfiguration.background(withIdentifier: "com.rakhi.\(UUID().uuidString)")
//        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
//    }
//    
//    func downloadVideo(from url: URL,
//                       onProgress: @escaping (Float) -> Void,
//                       onCompletion: @escaping (URL?) -> Void,
//                       onError: @escaping (Error) -> Void) {
//        
//        self.onProgress = onProgress
//        self.onCompletion = onCompletion
//        self.onError = onError
//        
//        let downloadTask = urlSession.downloadTask(with: url)
//        downloadTask.resume()
//    }
//    
//    // MARK: - URLSessionDownloadDelegate
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
//                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
//                    totalBytesExpectedToWrite: Int64) {
//        
//        guard totalBytesExpectedToWrite > 0 else {
//            print("Unknown download size")
//            return
//        }
//        
//        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//        onProgress?(progress)
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
//                    didFinishDownloadingTo location: URL) {
//        
//        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destinationURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
//        
//        do {
//            if fileManager.fileExists(atPath: destinationURL.path) {
//                try fileManager.removeItem(at: destinationURL)
//            }
//            try fileManager.moveItem(at: location, to: destinationURL)
//            print("Video downloaded and saved to: \(destinationURL)")
//            onCompletion?(destinationURL)
//        } catch {
//            print("Error saving video: \(error.localizedDescription)")
//            onError?(error)
//        }
//    }
//    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let error = error {
//            print("Download failed: \(error.localizedDescription)")
//            onError?(error)
//        }
//    }
//}


import Foundation

class VideoDownloader: NSObject, URLSessionDownloadDelegate {
    
    private var urlSession: URLSession!
    private var downloadTask: URLSessionDownloadTask?
    private var resumeData: Data?
    
    // Closures
    private var onProgress: ((Float) -> Void)?
    private var onCompletion: ((URL?) -> Void)?
    private var onError: ((Error) -> Void)?
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.rakhi.\(UUID().uuidString)")
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func downloadVideo(from url: URL,
                       onProgress: @escaping (Float) -> Void,
                       onCompletion: @escaping (URL?) -> Void,
                       onError: @escaping (Error) -> Void) {
        
        self.onProgress = onProgress
        self.onCompletion = onCompletion
        self.onError = onError
        
        downloadTask = urlSession.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    func pauseDownload() {
        downloadTask?.cancel(byProducingResumeData: { [weak self] data in
            guard let self = self else { return }
            self.resumeData = data
            self.downloadTask = nil
            print("Download paused, resume data saved.")
        })
    }
    
    func resumeDownload() {
        guard let resumeData = resumeData else {
            print("No resume data available. Cannot resume.")
            return
        }
        downloadTask = urlSession.downloadTask(withResumeData: resumeData)
        downloadTask?.resume()
        self.resumeData = nil
        print("Download resumed.")
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite > 0 else {
            print("Unknown download size")
            return
        }
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        onProgress?(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.moveItem(at: location, to: destinationURL)
            print("Video downloaded and saved to: \(destinationURL)")
            onCompletion?(destinationURL)
        } catch {
            print("Error saving video: \(error.localizedDescription)")
            onError?(error)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError?,
           let resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            // Save resume data if available
            self.resumeData = resumeData
            print("Download failed but resume data captured.")
        } else if let error = error {
            print("Download failed: \(error.localizedDescription)")
            onError?(error)
        }
    }
}
