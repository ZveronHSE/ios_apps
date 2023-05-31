//
//  AddingPageViewController.swift
//  ConsumerApp
//
//  Created by alexander on 12.05.2023.
//

import Foundation
import UIKit

class AddingPageViewController: UIPageViewController {

    var pages: [UIViewController] = [
        AdsViewController(),
        OrderViewController()
    ]

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color1.background
        dataSource = self
        delegate = nil

        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
}

// typical Page View Controller Data Source
extension AddingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return nil }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return nil }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
}

class RootAddingViewController: UIViewControllerWithAuth {

    let firstPage: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Объявления", for: .normal)
        v.titleLabel?.font = Font.robotoSemiBold20
        v.tintColor = Color1.gray5.withAlphaComponent(0.9)
        v.addTarget(self, action: #selector(selectFirstPage), for: .touchUpInside)
        return v
    }()

    let secondPage: UIButton = {
        let v = UIButton(type: .system)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Заказы", for: .normal)
        v.tintColor = Color1.gray4.withAlphaComponent(0.7)
        v.titleLabel?.font = Font.robotoSemiBold20
        v.addTarget(self, action: #selector(selectSecondPage), for: .touchUpInside)
        v.transform = .init(scaleX: 0.8, y: 0.8)
        return v
    }()

    let myContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Color1.background
        return v
    }()

    var thePageVC: AddingPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = Color1.background

        // add myContainerView
        view.addSubview(firstPage)
        view.addSubview(secondPage)
        view.addSubview(myContainerView)

        // constrain it - here I am setting it to
        //  40-pts top, leading and trailing
        //  and 200-pts height




        NSLayoutConstraint.activate([
            firstPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstPage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

            secondPage.topAnchor.constraint(equalTo: firstPage.topAnchor),
            secondPage.leftAnchor.constraint(equalTo: firstPage.rightAnchor, constant: 12),

            myContainerView.topAnchor.constraint(equalTo: firstPage.bottomAnchor, constant: 16),
            myContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // instantiate MyPageViewController and add it as a Child View Controller
        thePageVC = AddingPageViewController()
        addChild(thePageVC)

        // we need to re-size the page view controller's view to fit our container view
        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false

        // add the page VC's view to our container view
        myContainerView.addSubview(thePageVC.view)

        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            thePageVC.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 0.0),
            thePageVC.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
            thePageVC.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
            thePageVC.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0),
        ])

        thePageVC.delegate = self
        thePageVC.didMove(toParent: self)
    }

    func selectButton(indx: Int) {
        if indx == 0 {
            UIView.animate(withDuration: 0.3) {
                self.firstPage.tintColor = Color1.gray5.withAlphaComponent(0.9)
                self.secondPage.tintColor = Color1.gray4.withAlphaComponent(0.7)
                self.firstPage.transform = .identity
                self.secondPage.transform = .init(scaleX: 0.9, y: 0.9)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.secondPage.tintColor = Color1.gray5.withAlphaComponent(0.9)
                self.firstPage.tintColor = Color1.gray4.withAlphaComponent(0.7)
                self.firstPage.transform = .init(scaleX: 0.9, y: 0.9)
                self.secondPage.transform = .identity
            }
        }
    }

    @objc func selectFirstPage() {
        selectButton(indx: 0)
        thePageVC.setViewControllers([thePageVC.pages[0]], direction: .reverse, animated: true)

    }

    @objc func selectSecondPage() {
        selectButton(indx: 1)
        thePageVC.setViewControllers([thePageVC.pages[1]], direction: .forward, animated: true)
    }

}

extension RootAddingViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers.first as? AdsViewController != nil {
                selectButton(indx: 1)

            } else {
                selectButton(indx: 0)
            }
        }
    }
}
