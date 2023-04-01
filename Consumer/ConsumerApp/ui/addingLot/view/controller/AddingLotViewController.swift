//
//  AddingLotViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 28.04.2022.
//

import UIKit
import RxSwift
import ConsumerDomain
import ObjectstorageGRPC
import ZveronNetwork

class AddingLotViewController: UIViewController {
    @IBOutlet weak var typeLotLabel: UILabel!
    @IBOutlet weak var addingImageLabel: UILabel!
    @IBOutlet weak var typeAnimalBtn: UIButton!
    @IBOutlet weak var typeLotAnimalBtn: UIButton!

    @IBOutlet weak var nameLotLabel: UILabel!
    @IBOutlet weak var nameLotField: UITextField!
    @IBOutlet weak var exampleLotLabel: UILabel!
    @IBOutlet weak var alert: Alert!
    @IBOutlet weak var continueBtn: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    let buttonAddImage = UIButton()
    let corner = Corner.mainButton.rawValue
    private let viewModel = ViewModelFactory.get(AddingLotViewModel.self)

    private var selectedImage: Data!

    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    let navBtn = NavigationButton.close.button

    var dataForNextVC: [TableInfo]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViews()
    }

    public func setup() {
        scrollView.backgroundColor = Color.backgroundScreen.color
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        typeLotLabel.text = "Тип объявления"
        typeLotLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)

        typeLotAnimalBtn.setTitle("Товары для животных", for: .normal)
        typeLotAnimalBtn.contentHorizontalAlignment = .center
        typeLotAnimalBtn.tintColor = .black
        typeLotAnimalBtn.layer.cornerRadius = corner
        typeLotAnimalBtn.clipsToBounds = true
        typeLotAnimalBtn.applyGradientForBorder(.mainButton, .horizontal, 2, corner)

        typeAnimalBtn.setTitle("Животные", for: .normal)
        typeAnimalBtn.contentHorizontalAlignment = .center
        typeAnimalBtn.tintColor = .black
        typeAnimalBtn.layer.cornerRadius = corner
        typeAnimalBtn.clipsToBounds = true
        typeAnimalBtn.applyGradientForBorder(.mainButton, .horizontal, 2, corner)
        self.typeAnimalBtn.applyGradient(.mainButton, .horizontal, 10)

        addingImageLabel.text = "Добавьте фотографии"
        addingImageLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        nameLotLabel.text = "Укажите название"
        nameLotLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        exampleLotLabel.text = "Например: Кошка «Леля». 3 года"
        exampleLotLabel.font = .systemFont(ofSize: FontSize.tipLot.rawValue)
        exampleLotLabel.textColor = .gray
        continueBtn.setTitle("Далее", for: .normal)
        continueBtn.contentHorizontalAlignment = .center
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.layer.cornerRadius = corner
        continueBtn.clipsToBounds = true
        continueBtn.applyGradient(.mainButton, .horizontal, corner)
        continueBtn.alpha = 0.5
        continueBtn.isEnabled = false

        buttonAddImage.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        buttonAddImage.backgroundColor = .white
        buttonAddImage.setTitle("Добавьте\nфотографию", for: .normal)
        buttonAddImage.setTitleColor(.black, for: .normal)
        buttonAddImage.titleLabel?.numberOfLines = 0
        buttonAddImage.titleLabel?.textAlignment = .center
        buttonAddImage.titleLabel?.font = .systemFont(ofSize: 14)
        buttonAddImage.layer.cornerRadius = 8
        buttonAddImage.translatesAutoresizingMaskIntoConstraints = false
        buttonAddImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
        let icon = UIImage(named: "plusGradient")!
        buttonAddImage.setImage(icon, for: .normal)
        buttonAddImage.imageView?.contentMode = .scaleAspectFit
        buttonAddImage.centerVertically()
        stackView.addArrangedSubview(buttonAddImage)
        alert.configure()
    }

    private func bindViews() {
        // Обработка нажатия на кнопку выбора типа животного
        typeAnimalBtn.rx.tap.bind(onNext: { _ in
            self.viewModel.isAnimalType.accept(true)
        }).disposed(by: disposeBag)

        // Обработка нажатия на кнопку выбора типа товара для животного
        typeLotAnimalBtn.rx.tap.bind(onNext: { _ in
            self.viewModel.isAnimalType.accept(false)
        }).disposed(by: disposeBag)

        // настраиваем отображение кнопок (distinctUntilChanged - чтобы событие не вызывалось при сете
        // одинаковых значений - статья https://habr.com/ru/post/281292/)
        viewModel.isAnimalType.distinctUntilChanged().bind(onNext: { isAnimalType in
            let categoryId: Int32 = self.viewModel.isAnimalType.value ? 1 : 2
            self.viewModel.getLotForms(categoryId: categoryId)
            if isAnimalType {
                self.typeAnimalBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
                self.typeAnimalBtn.tintColor = .white

                self.typeLotAnimalBtn.removeGradientLayer(layerIndex: 0)
                self.typeLotAnimalBtn.tintColor = .black
            } else {
                self.typeAnimalBtn.removeGradientLayer(layerIndex: 0)
                self.typeAnimalBtn.tintColor = .black

                self.typeLotAnimalBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
                self.typeLotAnimalBtn.tintColor = .white
            }
        }).disposed(by: disposeBag)


        buttonAddImage.rx.tap.bind(onNext: {
            let provider = CameraProvider(delegate: self)
            do {
                if self.viewModel.photoLot.count < 5 {
                    let picker = try provider.getImagePicker(source: .photoLibrary)
                    self.present(picker, animated: true)
                }
            } catch {
                NSLog("Error: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)




        nameLotField.rx.text.changed.bind(to: viewModel.nameLot).disposed(by: disposeBag)

        // Обработка показа/скрытия предупреждения
        viewModel.alert.bind(onNext: { alertModel in
            guard let alertModel = alertModel else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: alertModel.mode, message: alertModel.message)
            self.exampleLotLabel.isHidden = true
        }).disposed(by: disposeBag)


        // Обработка состояния кнопки продолжить
        viewModel.continueBtn.bind(onNext: { isEnabled in
            self.continueBtn.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.continueBtn.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)

        continueBtn.rx.tap.bind(onNext: { _ in
            self.viewModel.uploadImage(image: self.selectedImage).subscribe(onNext: { url in
                var titleLot = self.viewModel.nameLot.value
                let categoryId: Int32 = self.viewModel.isAnimalType.value ? 1 : 2
                titleLot?.capitalizeFirstLetter()
                var lot = CreateLot(
                    title: titleLot!,
                    photos: [Photo(url: url, order: 0)],
                    parameters: [:],
                    description: "",
                    price: 0,
                    communication_channel: [],
                    address: FullAddress(longitude: 0, latitude: 0),
                    lot_form_id: 0,
                    category_id: categoryId
                )

                let vc = AddingLotTypeViewController()
                vc.setUpData(data: self.dataForNextVC, lot: lot)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)


        viewModel.lotForms
            .subscribe(onNext: { lots in
            self.dataForNextVC = lots.map { TableInfo(title: $0.name, subtitle: nil, id: $0.id) }
        }).disposed(by: disposeBag)


        navBtn.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

    }




    func addImageInStack(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = Color.imageBorder.color.cgColor
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.clipsToBounds = true
        stackView.addArrangedSubview(imageView)
    }



}

extension AddingLotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        )

        // здесь нужно будет добавить обработку незагруженной фотки
        guard let image = image else { return }
        var images = viewModel.imagesLot.value
        images.append(image)
        viewModel.imagesLot.accept(images)
        addImageInStack(image)

        // TODO: здесь должна быть загрузка фото на сервер
        picker.dismiss(animated: true, completion: nil)

        selectedImage = resizeImage(image: image, targetSize: CGSize(width: 800, height: 800))!.jpegData(compressionQuality: 1.0)
    }
}


func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size

    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
}

