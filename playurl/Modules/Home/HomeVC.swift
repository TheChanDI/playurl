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

    var popupView: SlidingView?
    
    var videoPlayer = YTPlayerView()
    
    var videoIdList: [VideoIDModel] = [.init(id: "LTbKXDNjQ3w", name: "Purana kura"), .init(id: "wy59p5FEDA8", name: "Love hurts"), .init(id: "EQJxzSZM_mI", name: "Lakhau hajarau")]
    
    lazy var blackView: UIView = {
       let v = UIView()
        v.isHidden = true
        v.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return v
    }()
    
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.allowsSelection = false
        tv.register(PlayerItemCell.self, forCellReuseIdentifier: PlayerItemCell.identifier)
        return tv
    }()
    
    lazy var bottomSlide = BottomSlideView()

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "playURL"

        popupView = SlidingView(view: self.view)
        
        // Do any additional setup after loading the view.
        configureSwipeGesture()
        configurePlayerView()
        configureTableView()
        loadVideo()
        configureBlackView()
        configureBottomSlide()
      
    }
    

    
    // MARK: UI Configuration
    
    private func configureSwipeGesture() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        bottomSlide.addGestureRecognizer(swipeGesture)
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
            make.top.equalTo(videoPlayer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureBlackView() {
        view.addSubview(blackView)
        blackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureBottomSlide() {
        view.addSubview(bottomSlide)
        bottomSlide.addVideoClosure = { [weak self] (data) in
            
            if data.id == "" || data.name == "" {
                self?.view.bringSubviewToFront((self?.popupView)!)
//                self?.navigationController?.navigationBar.bringSubviewToFront()
                self?.popupView?.startAnimation(with: .failure )
                self?.popupView?.messageLabel.text = "Fields are empty!"
                return
            }
            
            self?.videoIdList.append(.init(id: data.id, name: data.name))
            self?.tableView.reloadData()
            self?.closeView()
        }
        bottomSlide.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    // MARK: Methods
    
    private func loadVideo() {
        videoPlayer.load(withVideoId: "LTbKXDNjQ3w")

    }
    
    @objc func addVideoButtonTapped() {
        blackView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.bottomSlide.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func handleSwipe(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSlide)
        guard translation.y >= 0 else {return}

        bottomSlide.snp.updateConstraints { make in
            make.height.equalTo(300 - translation.y)
        }

        if sender.state == .ended {

            let dragVelocity = sender.velocity(in: bottomSlide)

            if dragVelocity.y >= 1300 {
                closeView()
            }
            else {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.bottomSlide.snp.updateConstraints { make in
                        make.height.equalTo(300)
                    }
                    self?.view.layoutIfNeeded()
                }

            }
        }
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.bottomSlide.snp.updateConstraints({ make in
                make.height.equalTo(0)
            })
            self?.view.layoutIfNeeded()
       
        }, completion: { _ in
            self.blackView.isHidden = true
        })
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= 0 && indexPath.row <= 2 {
            return false
        }
        else {
            return true
        }
    }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            videoIdList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
