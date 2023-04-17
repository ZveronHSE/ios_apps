//
//  PDFLoadService.swift
//  SpecialistApp
//
//  Created by alexander on 14.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class PDFLoadService: NSObject {

    public static let shared = PDFLoadService()

    private var cache: [String: URL] = [:]

    private override init() { }

    public func loadPdf(from networkUrl: String) -> Observable<URL> {
        Observable.create { [weak self] observer in

            self?.cache[networkUrl].flatMap { observer.onNext($0) } ??
            self?.load(form: networkUrl) { [weak self] documentUrl, error in
                if error == nil {
                    self?.cache[networkUrl] = documentUrl
                    observer.onNext(documentUrl!)
                } else { observer.onError(error!) }
            }

            return Disposables.create()
        }
    }

    private func load(form networkUrl: String, _ callback: @escaping((URL?, Error?) -> Void)) {
        guard let url = URL(string: networkUrl) else { return }

        let urlSession = URLSession(configuration: .default)

        let downloadTask = urlSession.downloadTask(with: url) { currentLocation, urlResponse, error in
            if error != nil { DispatchQueue.main.async { callback(nil, error) }; return }

            guard let fileName = urlResponse?.url?.lastPathComponent else { return }
            let destinationLocationDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationLocation = destinationLocationDirectory.appendingPathComponent(fileName)

            do {
                try FileManager.default.removeItem(at: destinationLocation)
                try FileManager.default.copyItem(at: currentLocation!, to: destinationLocation)
                DispatchQueue.main.async { callback(destinationLocation, nil) }
            } catch let error {
                DispatchQueue.main.async { callback(nil, error) }
            }
        }

        downloadTask.resume()
    }
}
