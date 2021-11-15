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
    
 
    
    var videoPlayer = YTPlayerView()
    
    var videoIdList: [VideoIDModel] = [.init(id: "LTbKXDNjQ3w", name: "Purana kura"), .init(id: "wy59p5FEDA8", name: "Love hurts"), .init(id: "EQJxzSZM_mI", name: "Lakhau hajarau")]
    
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PlayerItemCell.self, forCellReuseIdentifier: PlayerItemCell.identifier)
        return tv
    }()
    
    lazy var bottomSlide = BottomSlideView()

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "playURL"

        // Do any additional setup after loading the view.
        configurePlayerView()
        configureTableView()
        loadVideo()
        configureBottomSlide()
    }
    

    
    // MARK: UI Configuration
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
            make.top.equalTo(videoPlayer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureBottomSlide() {
        view.addSubview(bottomSlide)
        bottomSlide.isHidden = true
        bottomSlide.addVideoClosure = { [weak self] (data) in
            self?.videoIdList.append(.init(id: data.id, name: data.name))
            self?.tableView.reloadData()
            self?.bottomSlide.isHidden = true
        }
        bottomSlide.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    // MARK: Methods
    
    private func loadVideo() {
        videoPlayer.load(withVideoId: "LTbKXDNjQ3w")

    }
    
    @objc func addVideoButtonTapped() {
        bottomSlide.isHidden = false
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(frame: .init(x: -20, y: 0, width: 0, height: 0))
        button.setTitle("Add Video", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(addVideoButtonTapped), for: .touchUpInside)
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}
