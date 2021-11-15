//
//  BottomSlideView.swift
//  playurl
//
//  Created by ENFINY INNOVATIONS on 11/15/21.
//

import UIKit

class BottomSlideView: UIView {
    
    var addVideoClosure: (((id: String, name: String)) -> Void)?
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.text = "Add Youtube video Id"
        label.textAlignment = .center
        return label
    }()
    
    lazy var addButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Add", for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return btn
    }()
    
    lazy var idTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Add video ID"
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 50))
        tf.layer.cornerRadius = 4
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.leftViewMode = .always
        return tf
    }()
    
    lazy var nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Add video name"
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 50))
        tf.layer.cornerRadius = 4
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.leftViewMode = .always
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 14
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMinYCorner]
        backgroundColor = .white
        
        configurationLabel()
        configureIDTextfield()
        configureNameTextfield()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Configuration
    
    private func configurationLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
    }
    
    private func configureButton() {
        addSubview(addButton)
        addButton.addTarget(self, action: #selector(addVideo), for: .touchUpInside)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    private func configureIDTextfield() {
        addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    private func configureNameTextfield() {
        addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc func addVideo() {
        addVideoClosure?((idTextField.text!, nameTextField.text!))
        idTextField.text = ""
        nameTextField.text = ""
    }
}
