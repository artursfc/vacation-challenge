//
//  DesignSystem.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 24/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

enum DesignSystem {

    //- MARK: Inbox
    enum Inbox {
        /// UICollectionViewCompositionalLayout Item
        static let itemTopSpacing: CGFloat = 0
        static let itemLeadingSpacing: CGFloat = 10
        static let itemBottomSpacing: CGFloat = 0
        static let itemTrailingSpacing: CGFloat = 10

        static let itemFractionalWidth: CGFloat = 0.5
        static let itemFractionalHeight: CGFloat = 1.0

        /// UICollectionViewCompositionalLayout Group
        static let groupTopSpacing: CGFloat = 10
        static let groupLeadingSpacing: CGFloat = 20
        static let groupBottomSpacing: CGFloat = 10
        static let groupTrailingSpacing: CGFloat = 20

        static let groupFractionalWidth: CGFloat = 1.0
        static let groupFractionalHeight: CGFloat = 0.3
    }

    //- MARK: PlayerComponent
    enum PlayerComponent {
        /// Safe area for the elements inside the `Player Component`.
        static let widthMultiplier: CGFloat = 0.9
        static let heightMultiplier: CGFloat = 0.9

        /// Elements spacing
        static let spacingFromProgressSlider: CGFloat = 5
    }

    //- MARK: Archive
    enum Archive {
        static let rowHeight: CGFloat = 60
    }

    // MARK: Recorder
    enum Recorder {
        static let spacingFromBottom: CGFloat = 50
        static let recordButtonWidth: CGFloat = 100
        static let recordButtonHeight: CGFloat = 100

        static let spacingFromRecordButton: CGFloat = 50
        static let timestampLabelHeight: CGFloat = 30
        static let timestampLabelWidthMultiplier: CGFloat = 0.3
    }
}
