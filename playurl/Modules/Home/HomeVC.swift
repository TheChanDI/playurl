//
//  HomeVC.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 11/14/21.
//

import UIKit
import SnapKit
import youtube_ios_player_helper

class HomeVC: UIViewController {
    
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PlayerItemCell.self, forCellReuseIdentifier: PlayerItemCell.identifier)
        return tv
    }()
    
    var videoPlayer = YTPlayerView()
    
    let videoIdList: [VideoIDModel] = [.init(id: "LTbKXDNjQ3w", name: "Purana kura"), .init(id: "wy59p5FEDA8", name: "Love hurts"), .init(id: "EQJxzSZM_mI", name: "Lakhau hajarau")]

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "playURL"

        // Do any additional setup after loading the view.
        configurePlayerView()
        configureTableView()
        loadVideo()
    }
    
    // MARK: Methods
    
    private func loadVideo() {
        videoPlayer.load(withVideoId: "LTbKXDNjQ3w")

    }
    
    private func configurePlayerView() {
        view.addSubview(videoPlayer)
        videoPlayer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(250)
        }
    }
    
    private func configureTableView() {
    
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(videoPlayer.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    

}

// MARK: - Extensions
extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoIdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerItemCell.identifier, for: indexPath) as! PlayerItemCell
        cell.textLabel?.text = videoIdList[indexPath.row].name
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        videoPlayer.load(withVideoId: videoIdList[indexPath.row].id)
        videoPlayer.playVideo()
    }
    
}
