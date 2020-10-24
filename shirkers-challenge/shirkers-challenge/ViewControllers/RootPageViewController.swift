//
//  RootPageViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit
import CoreData
import os.log

/// Container UIViewController for the UIPageViewController used to
/// display the Archive, Inbox and Settings screen.
final class RootPageViewController: UIViewController {
    // MARK: - Properties
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

    /// The Core Data context used by the recorder. It should **only**
    /// used to perform Dependecy Injection.
    private let context: NSManagedObjectContext

    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter pages: UIViewController array with the pages being displayed.
    /// Should be passed through Dependency Injection using the init for this type.
    /// - Parameter pageViewController: UIPageViewController used to display all three main screens.
    /// - Parameter context: The Core Data context used by the recorder.
    /// It should **only** used to perform Dependecy Injection.
    init(pages: [UIViewController],
         pageViewController: UIPageViewController,
         context: NSManagedObjectContext) {
        self.pages = pages
        self.pageViewController = pageViewController
        self.context = context
        super.init(nibName: nil, bundle: nil)
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        os_log("RootPageViewController initialized.", log: .appFlow, type: .debug)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setUpPageControl()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(recordMemory))
        navigationItem.rightBarButtonItem?.tintColor = .memoraAccent

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTheme(_:)),
                                               name: Notification.Name("theme-changed"),
                                               object: nil)
    }

    // MARK: - @objc
    @objc private func recordMemory() {
        os_log("RootViewController should present recorder.", log: .appFlow, type: .debug)
        let recorder = RecordingController()
        let recorderViewModel = RecorderViewModel(recorder: recorder, context: context)
        let recorderViewController = RecorderViewController(viewModel: recorderViewModel)
        recorderViewController.modalPresentationStyle = .overFullScreen

        present(recorderViewController, animated: true, completion: nil)
    }

    @objc private func didChangeTheme(_ notification: NSNotification) {
        os_log("RootViewController should change theme.", log: .appFlow, type: .debug)
        navigationItem.rightBarButtonItem?.tintColor = .memoraAccent
        setUpPageControl()

    }

    // MARK: - Views setup
    private func setUpPageControl() {
        view.backgroundColor = .memoraBackground
        for subView in pageViewController.view.subviews {
            if let pageControl = subView as? UIPageControl {
                pageControl.pageIndicatorTintColor = .memoraFill
                pageControl.currentPageIndicatorTintColor = .memoraAccent
            }
        }
    }

    // MARK: - Layout
    /// Configures the UIPageViewController with the pages passed through
    /// the init. It also layouts all the necessary constraints for this view.
    private func setupPageViewController() {
        pageViewController.setViewControllers([pages[middlePageIndex]], direction: .forward, animated: true, completion: nil)
        title = pages[middlePageIndex].title

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageViewController.view)

        guard let pageViewControllerView = pageViewController.view else {
            os_log("RootViewController failed to access pageViewController.view.", log: .appFlow, type: .error)
            return
        }

        NSLayoutConstraint.activate([
            pageViewControllerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewControllerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageViewControllerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageViewControllerView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
        os_log("RootViewController deinitialized.", log: .appFlow, type: .debug)
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
