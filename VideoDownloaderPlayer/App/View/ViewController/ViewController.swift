//
//  ViewController.swift
//  VideoDownloaderPlayer
//
//  Created by Rakhi Kumari on 27/04/25.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    
    private let viewModel = ViewModel()
    private var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videos = viewModel.videos
        tableView.reloadData()
        if let downloadedVideos = UserDefaults.standard.downloadedVideos{
            downloadedVideos.forEach { downloadedVideo in
                if let index = self.videos.firstIndex(where: {$0.url == downloadedVideo.remoteUrl}){
                    videos[index].isDownloading = false
                    videos[index].progress = 1
                    videos[index].downloadedUrl = downloadedVideo.downloadedUrl
                    videos[index].isDownloaded = true
                }
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        cell.video = videos[indexPath.row]
        cell.downloadButton.tag = indexPath.row
        cell.downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(didTapPlayVideo), for: .touchUpInside)
//        cell.onPauseButtonTapped = { [weak self] in
//            guard let self else { return }
//            self.viewModel.pauseDownload(video: videos[indexPath.row])
//        }
        
        // In ViewController where the cell is being configured:

        cell.onPauseButtonTapped = { [weak self] in
            guard let self else { return }
            if let video = cell.video {
                // Check if the video is paused
                if video.isPaused {
                    self.viewModel.resumeDownload(video: video)  // Resume the download
                } else {
                    self.viewModel.pauseDownload(video: video)  // Pause the download
                }
            }
        }


        return cell
    }
    
    @objc func didTapDownload(_ button: UIButton){
        let video = videos[button.tag]
        if let downloadedUrl = video.downloadedUrl{
            do{
                if var downloadedVideos = UserDefaults.standard.downloadedVideos{
                    downloadedVideos.removeAll(where: {$0.remoteUrl == video.url})
                    UserDefaults.standard.downloadedVideos = downloadedVideos
                }
                try FileManager.default.removeItem(at: downloadedUrl)
                video.downloadedUrl = nil
                video.isDownloaded = false
                video.progress = nil
                video.error = nil
            }
            catch let error{
                video.error = error
            }
        }
        else{
            video.error = nil
            viewModel.downloadVideo(video: video)
        }
    }
    
    @objc func didTapPlayVideo(_ button: UIButton){
        guard let url = videos[button.tag].downloadedUrl else { return }
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        present(playerViewController, animated: true)
        playerViewController.player?.play()
    }
    
}
