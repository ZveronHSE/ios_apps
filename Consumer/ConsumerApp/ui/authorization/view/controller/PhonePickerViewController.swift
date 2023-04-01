//
//  NumberPickerViewController.swift
//  iosapp
//
//  Created by alexander on 04.03.2022.
//

import UIKit
import InputMask
import RxSwift
import RxCocoa

class PhonePickerViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var subTopicLabel: UILabel!
    @IBOutlet weak var inputMask: NotifyingMaskedTextFieldDelegate!
    @IBOutlet weak var inputPhoneTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var signInByPhoneAndPasswordButton: UIButton!
    @IBOutlet weak var alert: Alert!

    private var inputPhoneText: PublishSubject = PublishSubject<String>()

    // MARK: Properties
    let viewModel = ViewModelFactory.get(PhonePickerViewModel.self)
    let disposeBag: DisposeBag = DisposeBag()

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(closeAuthForm), for: .touchUpInside)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return UIBarButtonItem(customView: closeButton)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: remove this invoke, because it will be moved to navigator
        bind(to: viewModel)
        configureScreen()
        // registerForKeyboardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }

//    deinit{
//        removeKeyboardNotifications()
//    }

    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
        topicLabel.font = .systemFont(ofSize: FontSize.topic.rawValue, weight: .medium)
        topicLabel.textColor = Color.title.color
        subTopicLabel.numberOfLines = 0
        subTopicLabel.lineBreakMode = .byWordWrapping
        subTopicLabel.font = .systemFont(ofSize: FontSize.subTopic.rawValue, weight: .regular)
        subTopicLabel.textColor = Color.subTitle.color
        signInByPhoneAndPasswordButton.titleLabel?.font = .systemFont(ofSize: FontSize.subtitle.rawValue, weight: .regular)
        signInByPhoneAndPasswordButton.setTitleColor(Color.subTitle.color, for: .normal)
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        continueButton.layer.cornerRadius = Corner.mainButton.rawValue
        alert.configure()
        navigationItem.leftBarButtonItem = closeButton
        inputMask.editingListener = self
        inputMask.affinityCalculationStrategy = .wholeString
        inputMask.affineFormats = ["+7 [000] [000]-[00]-[00]"]
    }

    override func viewDidAppear(_ animated: Bool) {
        inputPhoneTextField.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    @objc
    private func closeAuthForm() {
        dismiss(animated: true)
        (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: false)
    }
}

extension PhonePickerViewController: NotifyingMaskedTextFieldDelegateListener {
    func onEditingChanged(inTextField: UITextField, range: NSRange?) {
        self.inputPhoneText.onNext(inTextField.text ?? "")
    }
}

// MARK: Binding view to viewModel
extension PhonePickerViewController: BindableView {

    func bind(to vm: PhonePickerViewModel) {

        let inputPhoneTrigger = inputPhoneText
            .asDriverOnErrorJustComplete()

        let sendCodeTrigger = continueButton.rx.tap
            .do(onNext: { self.view.endEditing(true) })
            .asDriverOnErrorJustComplete()

        let authByPasswordTrigger = signInByPhoneAndPasswordButton.rx.tap
            .do(onNext: { self.view.endEditing(true) })
            .asDriverOnErrorJustComplete()

        let input = PhonePickerViewModel.Input(
            sendCodeTrigger: sendCodeTrigger,
            inputPhoneTrigger: inputPhoneTrigger,
            authByPasswordTrigger: authByPasswordTrigger
        )

        let output = vm.transform(input: input)

        // TODO: when navigator will be implemented, transfer this code to VM
        output.sendCode.drive(onNext: {
            let toVC = ControllerFactory.get(CodePickerViewController.self)
            toVC.setUp(phoneNumber: self.inputPhoneTextField.text!)
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: disposeBag)

        // TODO: when navigator will be implemented, transfer this code to VM
        output.authByPassword.drive(onNext: {
            let toVC = ControllerFactory.get(PhonePasswordPickerViewController.self)
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: disposeBag)

        output.isButtonEnabled.drive(onNext: { isEnabled in
            UIView.animate(withDuration: 0.3) {
                self.continueButton.isEnabled = isEnabled
                self.continueButton.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)

        output.screenState.drive(onNext: {
            switch $0 {
            case .normal:
                self.inputPhoneTextField.textColor = .black
                self.alert.hidden()
            case .error(let error):
                self.inputPhoneTextField.textColor = .red
                self.alert.show(mode: .error, message: error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
}

// блок с обработкой клавиатуры
extension PhonePickerViewController {

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        UIView.animate(withDuration: 0.5) {
            self.continueButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)

            self.signInByPhoneAndPasswordButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)
        }
    }

    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.5) {
            self.continueButton.transform = .identity
            self.signInByPhoneAndPasswordButton.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
