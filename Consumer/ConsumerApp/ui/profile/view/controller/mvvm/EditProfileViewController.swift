//
//  SettingsProfileViewController.swift
//  iosapp
//
//  Created by Nikita on 17.03.2023.
//

import UIKit
import ZveronRemoteDataService
import ConsumerDomain

class EditProfileViewController: UIViewControllerWithAuth {
    
    private let viewModel = ViewModelFactory.get(EditProfileViewModel.self)
    
    private lazy var imageUser: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .gray
        return imgView
    }()
    private lazy var imageBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.height/2
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(self.imageUser.image , for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    
   
    private var textFieldName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Имя"
        textField.textAlignment = .left
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private var textFieldSurname: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Фамилия"
        textField.textAlignment = .left
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private var textFieldCity: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Город"
        textField.textAlignment = .left
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private var completeEditBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Corner.mainButton.rawValue
        return button
    }()
    
    let closeBtn = NavigationButton.close.button
    private var profileInfo: ProfileInfo!
    var closure: ((ProfileInfo) -> ())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.backgroundScreen.color
        layout()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        completeEditBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        imageBtn.imageView?.layer.cornerRadius = imageBtn.frame.height/2
    }
    
    func setup(with profileInfo: ProfileInfo) {
        navigationItem.title = "Редактирование"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        self.profileInfo = profileInfo
        textFieldName.text = profileInfo.name
        textFieldSurname.text = profileInfo.surname
        textFieldCity.text = profileInfo.address.town
        self.imageUser.kf.setImage(with: URL(string: "https://mirpozitiva.ru/wp-content/uploads/2019/11/1472042978_32.jpg"))
        
    }
    
    func layout() {
        self.view.addSubview(imageBtn)
        imageBtn.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        imageBtn.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(textFieldName)
        textFieldName.topAnchor.constraint(equalTo: self.imageBtn.bottomAnchor, constant: 40).isActive = true
        textFieldName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldName.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.view.addSubview(textFieldSurname)
        textFieldSurname.topAnchor.constraint(equalTo: self.textFieldName.bottomAnchor, constant: 16).isActive = true
        textFieldSurname.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldSurname.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldSurname.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.view.addSubview(textFieldCity)
        textFieldCity.topAnchor.constraint(equalTo: self.textFieldSurname.bottomAnchor, constant: 16).isActive = true
        textFieldCity.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldCity.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldCity.heightAnchor.constraint(equalToConstant: 48).isActive = true
 
        self.view.addSubview(completeEditBtn)
        completeEditBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        completeEditBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        completeEditBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        completeEditBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func bindViews() {
        completeEditBtn.rx.tap.bind(onNext: {
           let info = ProfileInfo.init (
                id: self.profileInfo.id,
                name: self.textFieldName.text!,
                surname: self.textFieldSurname.text!,
                imageUrl: self.profileInfo.imageUrl,
                rating: self.profileInfo.rating,
                address: Address.init (
                    region: self.profileInfo.address.region,
                    town: self.textFieldCity.text!,
                    longitude: self.profileInfo.address.longitude,
                    latitude: self.profileInfo.address.latitude
                ))
            self.viewModel.setProfileInfo(with: info)
            self.closure?(info)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        
        imageBtn.rx.tap.bind(onNext: {
            let provider = CameraProvider(delegate: self)
            do {
                    let picker = try provider.getImagePicker(source: .photoLibrary)
                    self.present(picker, animated: true)
            } catch {
                NSLog("Error: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
        
        
        closeBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        )
        // здесь нужно будет добавить обработку незагруженной фотки
        guard let image = image else { return }
        imageBtn.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
