//
//  TrackCell.swift
//  iMusic
//
//  Created by Max on 27.01.2024.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}


class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        
        trackImageView.sd_setImage(with: url)
    }
    
    
    @IBAction func addTrackAction(_ sender: Any) {
        print("44444")
        let defaults = UserDefaults.standard
//        defaults.set(25, forKey: "Age")
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cell, requiringSecureCoding: false) {
            print("SUCCESS!!!!!!!")
            defaults.set(savedData, forKey: "tracks")
        }
    }
    
    @IBAction func showInfoAction(_ sender: Any) {
        print("3333")
        let defaults = UserDefaults.standard
//        let age = defaults.integer(forKey: "Age")
//        print("Age: \(age )")
        
        if let savedTrack = defaults.object(forKey: "tracks") as? Data {
            if let decodedTrack = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? SearchViewModel.Cell {
                print("decodedTrack.trackName: \(decodedTrack.trackName)")
            }
        }
    }
    
}
