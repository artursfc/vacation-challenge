//
//  RootPageViewController.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 29/08/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

final class RootPageViewController: UIPageViewController {

    private let pages: [UIViewController]

    @AutoLayout private var pageControl: UIPageControl

    private var numberOfPages: Int {
        return pages.count
    }

    init(pages: [UIViewController]) {
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.delegate = self
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        if !pages.isEmpty {
            self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
            setupPageControl()
            title = pages.first?.title
        }
    }

    private func setupPageControl() {
        pageControl.currentPage = 1
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPageIndicatorTintColor = .memoraLightGray
        pageControl.pageIndicatorTintColor = .memoraMediumGray

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
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
