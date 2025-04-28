📥 Video Downloader Player
An iOS app built using UIKit that allows users to simultaneously download videos inside a UITableView, show download progress and percentage in each cell, handle errors with retry option, and play or delete downloaded videos.

✨ Features
* 📥 Simultaneous Video Downloading Download multiple videos at once in table view cells using background URLSession.
* 📊 Live Progress and Percentage Each cell shows real-time download progress with a progress bar and percentage label.
* 🎬 Play Downloaded Videos Tap to play downloaded videos using AVPlayerViewController.
* 🗑️ Delete Videos Delete downloaded videos directly from the app and free up storage.
* 🚫 Error Handling & Retry If a download fails, the cell shows an error message with a Retry button.
* 🔄 Resume After App Restarts Downloads continue in the background even if the app is minimized or temporarily suspended.
* ⏸️ Pause and Resume Downloads You can pause a download and resume it later. Each cell contains a button that toggles between Pause and Resume while the video is being downloaded.

🛠️ Built With
* Swift
* UIKit
* URLSession (Background Session)
* AVFoundation and AVKit
* FileManager for local file handling

📚 How It Works
* VideoDownloader: Handles downloading of videos using a background URLSession and reports progress, completion, or error via closures. It also manages pause and resume functionality for downloads.
* VideoCell: A custom UITableViewCell that displays:
    * Video title
    * Progress bar
    * Percentage label
    * Pause/Resume button
    * Retry button (only visible when download fails)
* ViewController:
    * Displays a list of video URLs.
    * Starts downloads automatically.
    * Updates each cell based on download status.
    * Allows users to pause or resume downloads.
    * Plays the video using AVPlayerViewController once the download is complete.
    * Deletes video files locally when the user chooses.

🚀 Getting Started
1. Clone the repo: https://github.com/KumariRakhi190/VideoDownloader-Player.git
2. Open the project in Xcode.
3. Run the app on a simulator or device.
   
⚠️ Note: Simulator does not fully simulate background download behavior. Test on a real device for best results.

❤️ Acknowledgments
* Thanks to Apple's Documentation on URLSessionDownloadDelegate and AVPlayerViewController.
* Inspired by real-world apps needing offline video playback.
