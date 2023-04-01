//
//  AUTH.swift
//  iosapp
//
//  Created by alexander on 11.05.2022.
//

import Foundation
import UIKit
import BottomSheet
import RxCocoa
import RxSwift
import AuthGRPC
import ConsumerDomain

class AuthNavigationViewController: UINavigationController {
    var myDelegate: AuthCompleteDelegate?
}

public class UIViewControllerWithAuth: UIViewController {
    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    private let externalViewModel = ViewModelFactory.get(ExternalAuthViewModel.self)

    let disposeBag: DisposeBag = DisposeBag()

    private let authClicked: PublishSubject<AuthProvider> = PublishSubject()

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: externalViewModel)
    }

    func presentAutharization() {
        let authVC = MainAuthViewController()
        let navigationController = BottomSheetNavigationController(rootViewController: authVC, configuration: .default)
        self.transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        authVC.delegate = self
        navigationController.transitioningDelegate = self.transitionDelegate
        navigationController.modalPresentationStyle = .custom
        self.present(navigationController, animated: true)
    }

    func presentAuthorizationWithAlert(message: String) {
        self.presentAlert(
            message: message,
            style: .alert,
            actions: [
                UIViewController.AlertButton(
                    title: "Ок",
                    style: .default,
                    handler: { _ in self.presentAutharization() }
                )
            ]
        )
    }
}

// MARK: Binding view to viewModel
extension UIViewControllerWithAuth: BindableView {

    func bind(to viewModel: ExternalAuthViewModel) {

        let authTrigger = authClicked
        // TODO: remove this when navigator will be implemented
        .do(onNext: { _ in self.dismiss(animated: true) })
            .asDriverOnErrorJustComplete()

        let input = ExternalAuthViewModel.Input(authTrigger: authTrigger)

        let output = viewModel.transform(input: input)

        output.auth
        // TODO: remove dismiss controller when navigator will be implemented
        .drive(onNext: {
            self.dismiss(animated: true)
            self.didCompleteAuth(isSuccessAuth: true)
        })
            .disposed(by: disposeBag)

        output.cancelAuth
        // TODO: remove presentation controller when navigator will be implemented
        .drive(onNext: { self.presentAutharization() })
            .disposed(by: disposeBag)

        output.errors.drive(onNext: {_ in
            self.didCompleteAuth(isSuccessAuth: false)
            self.presentAlert(title: "Ошибка", message: "При авторизации произошла неизвестная ошибка. Попробуйте другой способ авторизации")
        })
            .disposed(by: disposeBag)
    }
}

extension UIViewControllerWithAuth: BottomSheetModalDismissalHandler, BottomSheetPresentationControllerFactory {
    public var canBeDismissed: Bool { true }

    public func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }

    public func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
            .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self,
            configuration: .default
        )
    }
}

extension UIViewControllerWithAuth: AuthPickerDelegate {
    func didClickExternalAuth(provider: AuthProvider) {
        authClicked.onNext(provider)
    }

    func didClickAuthByPhone() {
        let vc = ControllerFactory.get(PhonePickerViewController.self)
        let navigation = AuthNavigationViewController(rootViewController: vc)
        navigation.myDelegate = self
        navigation.modalPresentationStyle = .fullScreen

        self.dismiss(animated: true) {
            self.present(navigation, animated: true)
        }
    }
}

extension UIViewControllerWithAuth: AuthCompleteDelegate {
    func didCompleteAuth(isSuccessAuth: Bool) { }
}

@objc
protocol AuthCompleteDelegate: AnyObject {
    func didCompleteAuth(isSuccessAuth: Bool)
}
