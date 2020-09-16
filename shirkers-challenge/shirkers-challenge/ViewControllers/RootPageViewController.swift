//
//  RootPageViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RootPageViewController: UIViewController {

    private let pageViewController: UIPageViewController
    private let pages: [UIViewController]

    @AutoLayout private var pageControl: UIPageControl

    private var numberOfPages: Int {
        return pages.count
    }

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControl()
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        title = pages.first?.title

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageViewController.view)

        guard let pageViewControllerView = pageViewController.view else {
            /// - TODO: Add error handling
            return
        }

        NSLayoutConstraint.activate([
            pageViewControllerView.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewControllerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageViewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            pageViewControllerView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

    private func setupPageControl() {
        pageControl.currentPage = 1
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPageIndicatorTintColor = .memoraLightGray
        pageControl.pageIndicatorTintColor = .memoraMediumGray
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension RootPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let pages = pageViewController.viewControllers {
            if let firstPage = pages.first {
                if let newCurrentPage = self.pages.firstIndex(of: firstPage) {
                    self.pageControl.currentPage = newCurrentPage
                    title = firstPage.title
                }
            }
        }
    }

}

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

}
