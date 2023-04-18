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

    private var cache: [URL: URL] = [:]

    private override init() { }

    public func loadPdf(from networkUrl: URL) -> Observable<URL> {
        Observable.create { [weak self] observer in

            self?.cache[networkUrl].flatMap { observer.onNext($0) } ??
            self?.load(from: networkUrl) { [weak self] documentUrl, error in
                if error == nil {
                    self?.cache[networkUrl] = documentUrl
                    observer.onNext(documentUrl!)
                } else { observer.onError(error!) }
            }

            return Disposables.create()
        }
    }

    private func load(from networkUrl: URL, _ callback: @escaping((URL?, Error?) -> Void)) {
        let url = networkUrl

        let urlSession = URLSession(configuration: .default)

        let downloadTask = urlSession.downloadTask(with: url) { currentLocation, urlResponse, error in
            if error != nil { DispatchQueue.main.async { callback(nil, error) }; return }

            guard let fileName = urlResponse?.url?.lastPathComponent else { return }
            let destinationLocationDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationLocation = destinationLocationDirectory.appendingPathComponent(fileName)

            try? FileManager.default.removeItem(at: destinationLocation)

            do {
                try FileManager.default.copyItem(at: currentLocation!, to: destinationLocation)
                DispatchQueue.main.async { callback(destinationLocation, nil) }
            } catch let error {
                DispatchQueue.main.async { callback(nil, error) }
            }
        }

        downloadTask.resume()
    }
}
