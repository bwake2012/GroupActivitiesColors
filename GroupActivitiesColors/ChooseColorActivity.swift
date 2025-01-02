//
//  ChooseColorActivity.swift
//  GroupActivitiesColors
//
//  Created by Bob Wakefield on 6/10/21.
//

import GroupActivities
import UIKit

struct ChooseColorActivity: GroupActivity {

    // specify the activity type to the system
    static let activityIdentifier = "net.cockleburr.sample.choose-color"

    // provide information about the activity
    var metadata: GroupActivityMetadata {

        var metadata = GroupActivityMetadata()

        metadata.type = .generic
        metadata.title = NSLocalizedString("Choose Color by Bob Wakefield", comment: "")
        metadata.subtitle = NSLocalizedString("Transmits and receives names of color picture files for display.", comment: "")

        return metadata
    }
}

