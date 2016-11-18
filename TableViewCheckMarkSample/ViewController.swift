//
//  ViewController.swift
//  TableViewCheckMarkSample
//
//  Created by RS on 2016/11/11.
//  Copyright © 2016年 RS. All rights reserved.
//

import UIKit
import AVFoundation

import JEToolkit


// MARK: - ViewController

class ViewController: UIViewController {
    
    
    // MARK: Internal
    
    internal enum Music: Int {
        
        case bach
        case beethoven
        case pachelbel
        
        static let items: [Music] = [.bach, .beethoven, .pachelbel]
        
        static var selectedItem: Music?
        
        static func count() -> Int {
            
            return items.count
        }
        
        func imageName() -> String {
            
            switch self {
                
            case .bach: return "Bach.jpg"
            case .beethoven: return "Beethoven.jpg"
            case .pachelbel: return "Pachelbel.jpg"
            }
        }
        
        func fileName() -> String{
            
            switch self {
                
            case .bach: return "aria"
            case .beethoven: return "elise"
            case .pachelbel: return "cannon"
            }
        }
        
        func createrName() -> String {
            
            switch self {
                
            case .bach: return "Bach"
            case .beethoven: return "Beethoven"
            case .pachelbel: return "Pachelbel"
            }
        }
        
        static func next() -> (Music, Music) {
            
            let formerItem: Music = self.selectedItem ?? .bach
            self.selectedItem = {
                
                if let item: Music = selectedItem {
                    
                    switch item {
                        
                    case .bach: return .beethoven
                    case .beethoven: return .pachelbel
                    case .pachelbel: return .bach
                    }
                }
                else {
                    
                    return .bach
                }
            }()
            
            return (formerItem, selectedItem!)
        }
        
        static func back() -> (Music, Music) {
            
            let formerItem: Music = self.selectedItem ?? .bach
            self.selectedItem = {
                
                if let item: Music = selectedItem {
                    
                    switch item {
                        
                    case .bach: return .pachelbel
                    case .beethoven: return .bach
                    case .pachelbel: return .beethoven
                    }
                }
                else {
                    
                    return .bach
                }
            }()
            
            return (formerItem, self.selectedItem!)
        }
    }
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    // MARK: Fileprivate
    
    fileprivate func audioPlay(of index: Int) {
        
        guard let item: Music = Music(rawValue: index),
            let songPath: String = Bundle.main.path(forResource: item.fileName(), ofType: "mp3"),
            let url: URL = URL(string: songPath) else {
            
            return
        }
        
        do {
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            Music.selectedItem = item
            audioPlayer?.play()
        }
        catch let error{
            
            print(error)
            return
        }
    }
    
    
    // MARK: Private
    
    private var audioPlayer: AVAudioPlayer?
    
    @IBOutlet private weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBAction private func selectNext(sender: UIButton) {
        
        let item: (Music, Music) = Music.next()
        self.audioPlay(of: item.1.hashValue)
        self.selectRow(of: item.1.hashValue)
        self.deselectRow(of: item.0.hashValue)
    }
    
    @IBAction private func selectBack(sender: UIButton) {
        
        let item: (Music, Music) = Music.back()
        self.audioPlay(of: item.1.hashValue)
        self.selectRow(of: item.1.hashValue)
        self.deselectRow(of: item.0.hashValue)
    }
    
    @IBAction private func selectPlay(sender: UIButton) {
        
        if audioPlayer?.isPlaying == true {
            
            audioPlayer?.stop()
        }
        else if audioPlayer?.isPlaying == false {
            
            audioPlayer?.play()
        }
        else {
            
            if let item: Music = Music.selectedItem {
                
                self.audioPlay(of: item.hashValue)
            }
            else {
                
                let item: Music = {
                    
                    Music.selectedItem = .bach
                    return Music.selectedItem!
                }()
                
                self.audioPlay(of: item.hashValue)
            }
        }
    }
    
    private func selectRow(of row: Int) {
        
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            
            return
        }
        cell.accessoryType = .checkmark
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    private func deselectRow(of row: Int) {
        
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            
            return
        }
        cell.accessoryType = .none
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Music.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(with: TableViewCell.self, for: indexPath) as? TableViewCell else {
            
            return UITableViewCell()
        }
        
        cell.item = Music(rawValue: indexPath.row)!
        return cell
    }
}


// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.audioPlay(of: indexPath.row)
        
        guard let cell: TableViewCell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            
            return
        }
        
        cell.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell: TableViewCell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            
            return
        }
        
        cell.accessoryType = .none
    }
}
