//
//  TrackDetailView.swift
//  iMusic
//
//  Created by Max on 28.01.2024.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}



class TrackDetailView: UIView {
    
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var maximizeStackView: UIStackView!
    
    
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        trackImageView.backgroundColor = .cyan
        
        setupGestures()
        
//        miniPlayPauseButton.configuration!.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    }
    
    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        miniTrackImageView.sd_setImage(with: url)
        trackImageView.sd_setImage(with: url)
        
    }
    
    private func setupGestures() {
        
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }

    
    private func playTrack(previewUrl: String?) {
        print("Try on track from link: \(previewUrl ?? "No track")")
        
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Maximizing and minimizing gesture
    
    @objc private func handleTapMaximized() {
        print("Taping to maximize")
        self.tabBarDelegate?.maximizeTrackDetailControler(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("began gesture")
        case .changed:
            print("changed gesture")
            handlePanChanged(gesture: gesture)
        case .ended:
            print("ended gesture")
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("unknown default")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizeStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailControler(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizeStackView.alpha = 0
            }
        },
                       completion: nil)
    }
    
    // MARK: - Time setup
    
    private func monitorStartTime() {
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let time = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            
            let currentDurationTime = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            
            self?.durationLabel.text = "-\(currentDurationTime)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let persentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(persentage)
    }
    
    // MARK: - Animation
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.trackImageView.transform = .identity
        }

    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func handleCurrentTimerSlider(_ sender: Any) {
        
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimUnSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimUnSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        
        self.tabBarDelegate?.minimizeTrackDetailController()
//        self.removeFromSuperview()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        guard let cellViewModel = delegate?.moveBackForPreviousTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let cellViewModel = delegate?.moveForwardForPreviousTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            reduceTrackImageView()
        }
        
    }
    
}
