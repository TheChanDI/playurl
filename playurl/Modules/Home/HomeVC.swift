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
    var timerValue: (hr: Int, min: Int)?
    
    var videoPlayer = YTPlayerView()
    var timerLabel = UILabel()
    var timeService = TimerService()
    
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
        tv.register(PlayerItemCell.self, forCellReuseIdentifier: PlayerItemCell.identifier)
        return tv
    }()
    
    lazy var bottomSlide = BottomSlideView()
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.backgroundColor = .white
        picker.isHidden = true
        return picker
    }()
    
    lazy var doneButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Start", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.isHidden = true
        btn.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return btn
    }()
    
    lazy var cancelButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.isHidden = true
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    lazy var formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
//    lazy var timerView: UIView = {
//        let v = UIView()
//        v.addSubview(timerLabel)
//        timerLabel.text = "0h 0min"
//        timerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        timerLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//
//       return v
//    }()

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "playURL"
        
        popupView = SlidingView(view: (navigationController?.view)!)
        loadRealmData()
        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureSwipeGesture()
        configurePlayerView()
        configureTableView()
        loadVideo()
        configureBlackView()
        configureBottomSlide()
        configureUITimerPicker()
        configureDoneButton()
        configureCancelButton()
        
        
        
      
    }
    
    // MARK: UI Configuration
    
    private func configureNavigationBar() {
        let timerButton = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: #selector(timerButtonTapped))
        navigationItem.rightBarButtonItem = timerButton
        
        let timerView = UIView(frame: .init(x: 30, y: 0, width: 80, height: 30))
        timerLabel = UILabel(frame: .init(x: 0, y: 0, width: 80, height: 30))
        timerView.addSubview(timerLabel)
        timerLabel.text = "0min"
        timerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: timerView)
        
    }
    
    @objc func timerButtonTapped() {
        timePicker.isHidden = false
        doneButton.isHidden = false
        cancelButton.isHidden = false
    }
    
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
            self?.addToRealm(id: data.id, name: data.name)
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
    
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(datePickerDoneButtonTapped), for: .touchUpInside)
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(timePicker.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(view.frame.width / 2)
        }
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.trailing.equalTo(doneButton.snp.leading)
            make.bottom.equalTo(timePicker.snp.top)
        }
    }
    

    // MARK: Methods
    
    @objc func cancelButtonTapped() {
        timePicker.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    
    private func configureUITimerPicker() {
     
        view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
        timePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            
        }
    }
    
    @objc func pickerChanged(sender: UIDatePicker) {
        
        let dateComponenets = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        timerValue = (dateComponenets.hour!, dateComponenets.minute!)
 
    }
    
    @objc func datePickerDoneButtonTapped() {
        cancelButtonTapped()
        popupView?.startAnimation(with: .information )
        timerLabel.text = "\(timerValue?.min ?? 0)min"
        popupView?.messageLabel.text = "Timer Started !"
        timeService.startTime(time: timerValue?.min ?? 0)
        timeService.updateTimer = {[weak self] value in

                self?.timerLabel.text = "\(value)min"
                if value == 0 {
                    self?.popupView?.messageLabel.text = "Timer Ended!"
                    self?.popupView?.startAnimation(with: .information )
                    self?.videoPlayer.pauseVideo()
                    exit(0)
                }
        }
      
    }
    
    private func loadRealmData() {

        let newData = LocalVideoService.shared.readData().map { item in
            return VideoIDModel(id: item.videoId, name: item.videoName)
        }
        videoIdList.append(contentsOf: newData)
        tableView.reloadData()
    }
    
    private func addToRealm(id: String, name: String) {
        LocalVideoService.shared.writeData(id: id, name: name)
    }
    
    private func loadVideo() {
        videoPlayer.load(withVideoId: "LTbKXDNjQ3w")

    }
    
    @objc func addVideoButtonTapped() {
        blackView.isHidden = false
        UIView.animate(withDuration: 0.2) {
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
        cell.selectionStyle = .none
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
            LocalVideoService.shared.deleteData(id: videoIdList[indexPath.row].id)
            videoIdList.remove(at: indexPath.row)
         
            tableView.deleteRows(at: [indexPath], with: .fade)
            
         
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
