//
//  NamePasswordPickerViewModel.swift
//  iosapp
//
//  Created by alexander on 24.04.2022.
//

import Foundation
import RxRelay
import RxSwift
import ZveronRemoteDataService
import ConsumerDomain

class NamePasswordPickerViewModel: ViewModelType {
    // MARK: Events
    let registrationComplete = PublishRelay<Void>()
    let setErrorScreenState = PublishRelay<String?>()
    let completeButton = PublishRelay<Bool>()
    let name = PublishRelay<String?>()
    let password = PublishRelay<String?>()
    let alert = PublishRelay<AlertModel?>()

    // MARK: Processed Events
    private var isValidFields: Observable<Bool> {
        return Observable.combineLatest(isValidName, isValidPassword) { $0 && $1 }
    }
    private var isValidName: Observable<Bool> {
        return name.map {
            guard
                let nameAndSur = $0,
                nameAndSur.replacingOccurrences(of: " ", with: "").сyrillicCharactersOnly,
                let value = $0?.split(separator: " "),
                value.count == 2
                else {
                self.alert.accept(AlertModel(
                    message: "Имя и фамилия должны быть написаны кириллицей через пробел",
                    mode: .warning))
                return false
            }

            let name = String(value[0])
            let secondName = String(value[1])

            guard name.count >= 2 else {
                self.alert.accept(AlertModel(
                    message: "Имя должно содержать как минимум 2 символа",
                    mode: .warning))
                return false
            }

            guard secondName.count >= 2 else {
                self.alert.accept(AlertModel(
                    message: "Фамилия должна содержать как минимум 2 символа",
                    mode: .warning))
                return false
            }

            self.alert.accept(nil)
            return true
        }
    }
    private var isValidPassword: Observable<Bool> {
        return password.map {
            guard let value = $0 else { return false }

            guard value.range(of: "^(?=.*[а-яА-ЯёЁ]).{0,}", options: .regularExpression) == nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль не может содержать буквы кириллицы",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[A-Z].*[A-Z]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 2 буквы в верхнем регистре",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[a-z].*[a-z].*[a-z]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 3 буквы в нижнем регистре",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[!@#$&*]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 1 спец-символ ! @ # $ & *",
                    mode: .warning))
                return false
            }

            guard value.range(of: "^(?=.*[0-9].*[0-9]).{2,}$", options: .regularExpression) != nil else {
                self.alert.accept(AlertModel(
                    message: "Пароль должен содержать как минимум 2 цифры",
                    mode: .warning))
                return false
            }

            guard value.count >= 8 else {
                self.alert.accept(AlertModel(
                    message: "Пароль не может быть короче 8 символов",
                    mode: .warning))
                return false
            }

            self.alert.accept(nil)
            return true
        }
    }

    // MARK: Properties
    let disposeBag = DisposeBag()
    private let authUseCase: AuthUseCaseProtocol

    init(_ authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase

        setErrorScreenState.subscribe(onNext: { errorMessage in
            let isErrorState = errorMessage == nil
            if !isErrorState { self.completeButton.accept(false) }
            if !isErrorState { self.alert.accept(AlertModel(message: errorMessage!, mode: .error)) }
        }).disposed(by: disposeBag)

        isValidFields.bind(to: completeButton).disposed(by: disposeBag)
    }

    func registration(nameAndSurname: String, password: String) {

        var name = String(nameAndSurname.split(separator: " ")[0]).replacingOccurrences(of: " ", with: "")

        name.capitalizeFirstLetter()
        var surname = String(nameAndSurname.split(separator: " ")[1]).replacingOccurrences(of: " ", with: "")
        surname.capitalizeFirstLetter()

        authUseCase.registerByPhone(name: name, surname: surname, password: password).subscribe(
            onNext: { self.registrationComplete.accept(Void()) },
            onError: { self.setErrorScreenState.accept($0.localizedDescription) }
        ).disposed(by: disposeBag)
    }
}
