//
//  VideoTableViewCell.swift
//  VideoDownloaderPlayer
//
//  Created by Rakhi Kumari on 27/04/25.
//

import UIKit
import Combine

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadPercentageLabel: UILabel!
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    
    var cancellables: Set<AnyCancellable> = []
    var onPauseButtonTapped: (() -> Void)?

    var video: Video?{
        didSet{
            linkLabel.text = video?.url.absoluteString
            
            video?.$progress.sink(receiveValue: { [weak self] progress in
                guard let self else {return}
                if let progress = progress{
                    downloadProgressView.progress = progress
                    downloadPercentageLabel.text = "\(Int(progress * 100))%"
                }
                else{
                    downloadProgressView.progress = .zero
                    downloadPercentageLabel.text?.removeAll()
                }
            }).store(in: &cancellables)
            
            video?.$error.sink(receiveValue: { [weak self] error in
                guard let self else { return }
                if let error{
                    linkLabel.text = error.localizedDescription
                    linkLabel.textColor = .red
                    downloadButton.isEnabled = true
                    downloadButton.setImage(UIImage(systemName: "autostartstop.trianglebadge.exclamationmark"), for: .normal)
                }
                else{
                    linkLabel.text = video?.url.absoluteString
                    linkLabel.textColor = .label
                    downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
                }
            }).store(in: &cancellables)
            
            video?.$isDownloaded.sink(receiveValue: { [weak self] isDownloaded in
                guard let self else {return}
                if isDownloaded == true{
                    downloadButton.setImage(UIImage(systemName: "xmark.bin"), for: .normal)
                    playButton.isHidden = false
                }
                else{
                    downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
                    playButton.isHidden = true
                }
            }).store(in: &cancellables)
            
            video?.$isPaused.sink(receiveValue: { [weak self] isPaused in
                guard let self else { return }
                if isPaused {
                    pauseButtonOutlet.setImage(UIImage(systemName: "restart.circle"), for: .normal) // Resume icon
                } else {
                    pauseButtonOutlet.setImage(UIImage(systemName: "pause.circle"), for: .normal) // Pause icon
                }
            }).store(in: &cancellables)

            
//            video?.$isDownloading.sink(receiveValue: { [weak self] isDownloading in
//                guard let self else {return}
//                if isDownloading == true{
//                    downloadButton.isEnabled = false
//                }
//                else{
//                    downloadButton.isEnabled = true
//                }
//            }).store(in: &cancellables)
            
            video?.$isDownloading.sink(receiveValue: { [weak self] isDownloading in
                guard let self else { return }
                if isDownloading == true {
                    downloadButton.isEnabled = false
                    pauseButtonOutlet.isHidden = false  // 👈 SHOW Pause button when downloading
                } else {
                    downloadButton.isEnabled = true
                    pauseButtonOutlet.isHidden = true   // 👈 HIDE Pause button otherwise
                }
            }).store(in: &cancellables)

            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        onPauseButtonTapped = nil
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        onPauseButtonTapped?()
    }

    
    
}
