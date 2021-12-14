//
//  PopupView.swift
//  IOSJourney
//
//  Created by ENFINY INNOVATIONS on 7/15/21.
//

import UIKit

///This class is a custom class for animation view from top.
///Highly customizable.

final class SlidingView: UIView {
    
    ///Its a enum of message type.
    ///Types: Success, Failure, Warning and Information
     enum MessageType {
        case success
        case failure
        case warning
        case information
    }
    
    //MARK:- Property
    
    ///height for the popup view. default is 100.
    private var popupHeight: CGFloat {
        get {
            return 80
        }
    }
    
    ///animation duration. Default is 0.3
    private var animationDuration: TimeInterval = 0.3
    
    ///duration you want to show the animation for. Default is 1second
    private var animationTiming: TimeInterval = 1
    
    ///this property is for automatic dismiss of the view. Default is true. If you want the view to be dismiss by tapping then you can set it to false
    private var automaticDismiss: Bool = true {
        didSet {
            if !automaticDismiss {
                configureTouchableEvent()
            }
        }
    }
    
    private var mainView: UIView!
    
    private var topLayoutConstraint: NSLayoutConstraint?
    
    ///label for the popup view.
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is a popup message. You can edit me any time!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(view: UIView) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.968627451, alpha: 1)
        mainView = view
        setup()
    }
    
    //MARK:- Setup
    private func setup() {
        
        mainView.addSubview(self)
        
        //this is for sliding view frame setup
        topLayoutConstraint = topAnchor.constraint(equalTo: mainView.topAnchor, constant: -popupHeight)
        
        topLayoutConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            heightAnchor.constraint(equalToConstant: popupHeight)
        ])
        
        
        
        //this is for messabe label inside that slidingView
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
    }
    
    //MARK:- Methods
    
    /// start the animation. Default messageType is Information,  durationInterval = 0.3, durationTiming = 1, automaticDismission = true
    /// - Parameter type: MessageType
    /// - Parameter durationInterval: TimeInterval
    /// - Parameter durationTiming: TimerInterval
    /// - Parameter automaticDismission: Bool
    func startAnimation(with type: MessageType = .information,
                        animationDuration durationInterval: TimeInterval = 0.3,
                        animationTiming durationTiming: TimeInterval = 1,
                        isAutomatic automaticDismission: Bool = true) {
        
        switch type {
        case .success:
            backgroundColor = #colorLiteral(red: 0.4, green: 1, blue: 0.4, alpha: 1)
        case .failure:
            backgroundColor = #colorLiteral(red: 1, green: 0.0437336543, blue: 0.1019607843, alpha: 1)
        case .warning:
            backgroundColor = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.2196078431, alpha: 1)
        case .information:
            backgroundColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.968627451, alpha: 1)
        }
        
        animationDuration = durationInterval
        animationTiming = durationTiming
        automaticDismiss = automaticDismission
        
        
        layer.removeAllAnimations()
        
        if automaticDismiss {
            performAnimation()
        }
        else {
            UIView.animate(withDuration: animationDuration) {
                self.startAnimationBlock()
            }
            
        }
    }
    
    private func startAnimationBlock() {
        self.topLayoutConstraint?.constant = 0
        self.mainView.layoutIfNeeded()
    }
    
    private func endAnimationBlock() {
        self.topLayoutConstraint?.constant = -self.popupHeight
        self.topLayoutConstraint?.isActive = true
        self.mainView.layoutIfNeeded()
    }
    
    private func performAnimation() {
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.startAnimationBlock()
            
        } completion: { (_) in
            UIView.animate(withDuration: 0.2, delay: self.animationTiming) {
                self.endAnimationBlock()
            }
        }
    }
    
    //adding touchable event to this view
    private func configureTouchableEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewIsTapped))
        addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func viewIsTapped() {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.endAnimationBlock()
        }
        
    }
}

