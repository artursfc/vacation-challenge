//
//  RootPageViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

/// Container UIViewController for the UIPageViewController used to
/// display the Archive, Inbox and Settings screen.
final class RootPageViewController: UIViewController {
// - MARK: Properties

    /// UIPageViewController used to display all three main screens.
    private let pageViewController: UIPageViewController
    /// UIViewController array with the pages being displayed. Should
    /// be passed through Dependency Injection using the init for this type.
    private let pages: [UIViewController]

    /// The number of pages currently available. Convenience property used
    /// to avoid having to count the amount of pages in the array of
    /// pages
    private var numberOfPages: Int {
        return pages.count
    }

    /// The index of the middle page in the array of pages.
    /// It should be used to correctly build the `UIPageViewController`
    private var middlePageIndex: Int {
        return 1
    }

// - MARK: Init

    init(pages: [UIViewController], pageViewController: UIPageViewController) {
        self.pages = pages
        self.pageViewController = pageViewController
        super.init(nibName: nil, bundle: nil)
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// - MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(recordMemory))
        navigationItem.rightBarButtonItem?.tintColor = .memoraLightGray
    }

    //- MARK : @objc
    @objc private func recordMemory() {
        let recorderViewController = RecorderViewController()
        recorderViewController.modalPresentationStyle = .overFullScreen

        present(recorderViewController, animated: true, completion: nil)
    }

// - MARK: Layout

    /// Configures the UIPageViewController with the pages passed through
    /// the init. It also layouts all the necessary constraints for this view.
    private func setupPageViewController() {
        pageViewController.setViewControllers([pages[middlePageIndex]], direction: .forward, animated: true, completion: nil)
        title = pages[middlePageIndex].title

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageViewController.view)

        guard let pageViewControllerView = pageViewController.view else {
            /// - TODO: Add error handling
            return
        }

        NSLayoutConstraint.activate([
            pageViewControllerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewControllerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageViewControllerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageViewControllerView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
}

// - MARK: UIPageViewControllerDelegate

extension RootPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let pages = pageViewController.viewControllers {
            if let firstPage = pages.first {
                title = firstPage.title
            }
        }
    }

}

// - MARK: UIPageViewControllerDataSource

extension RootPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController) {
            if pageIndex > 0 {
                return pages[pageIndex - 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController) {
            if pageIndex < numberOfPages - 1 {
                return pages[pageIndex + 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return numberOfPages
    }

}
