//
//  PDFViewController.swift
//  SpecialistApp
//
//  Created by alexander on 14.04.2023.
//

import Foundation
import UIKit
import PDFKit

final class PDFViewController: UIViewController {

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.addAction(for: .touchUpInside) { [weak self] in self?.dismiss(animated: true) }
        closeButton.setImage(.zvClose, for: .normal)
        closeButton.tintColor = .zvWhite
        closeButton.backgroundColor = .zvGray3.withAlphaComponent(0.7)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()

    private let pdfView: PDFView = {
        let view = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.displayDirection = .vertical
        view.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.autoScales = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(pdfUrl: URL) {
        self.pdfView.document = PDFDocument(url: pdfUrl)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {
        view.addSubview(pdfView)
        view.addSubview(closeButton)

        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
        closeButton.layer.cornerRadius = closeButton.frame.size.height / 2
    }
}
