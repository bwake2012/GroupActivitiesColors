//
//  GroupActivitiesColorsViewsController.swift
//  GroupActivitiesColors
//
//  Created by Bob Wakefield on 6/10/21.
//

import UIKit
import GroupActivities

class GroupActivitiesColorsViewsController: UIViewController {

    private var activityHandler: GroupActivityHandler<ChooseColorActivity, ChooseColorMessage>?

    private var canConnect: Bool {

        activityHandler?.canConnect ?? false
    }

    private var isConnected: Bool {

        activityHandler?.isConnected ?? false
    }

    private var participantCount: Int {

        activityHandler?.participantCount ?? 0
    }

    var colorView: GroupActivitiesColorsView?

    var eligibilityStatusLabel: UILabel? {
        colorView?.eligibilityStatusLabel
    }

    var sessionStatusLabel: UILabel? {
        colorView?.sessionStatusLabel
    }

    var participantsStatusLabel: UILabel? {
        colorView?.participantsStatusLabel
    }

    var generalStatusLabel: UILabel? {
        colorView?.generalStatusLabel
    }

    var connectButton: UIButton? {
        colorView?.connectButton
    }

    var displayColor: String? {
        set {
            colorView?.displayColor = newValue
        }

        get {
            colorView?.displayColor
        }
    }

    var displayString: UILabel? {
        colorView?.currentColorLabel
    }

    var refreshButton: UIButton? {
        colorView?.refreshButton
    }

    var colorButtons: [UIButton] = []

    @objc func connectTapped(_ sender: UIButton) {

        if !isConnected {

            activityHandler?.activate()
        }
    }

    @objc func refreshTapped(_ sender: UIButton) {

        DispatchQueue.main.async {
            self.participantsStatusLabel?.text = "Participants: \(self.participantCount)"
            self.eligibilityStatusLabel?.text = self.canConnect ? "Eligible" : "Not eligible"
            self.sessionStatusLabel?.text = self.isConnected ? "Connected" : "Not connected"
            self.connectButton?.isEnabled = self.canConnect && !self.isConnected
        }
    }

    @objc func sendColorTapped(_ sender: UIButton) {

        guard let fileName = sender.accessibilityIdentifier else {

            preconditionFailure("Accessibility Identifier not defined for button tapped.")
        }

        let title = sender.accessibilityLabel ?? "No title"

        activityHandler?.send(message: ChooseColorMessage(fileName: fileName, title: title))

        print("Button tapped: \(title)")
    }

    override func loadView() {
        colorView = GroupActivitiesColorsView(frame: .zero)

        colorView?.connectButton.addTarget(self, action: #selector(self.connectTapped(_ :)), for: .touchUpInside)
        colorButtons = colorView?.colorButtons.compactMap {
            $0.addTarget(self, action: #selector(self.sendColorTapped(_:)), for: .touchUpInside)

            return $0
        } ?? []
        colorView?.refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)

        self.view = colorView
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureConnectButton()

        activityHandler = GroupActivityHandler(activity: ChooseColorActivity(), delegate: self)
        activityHandler?.beginWaitingForSessions()
    }
}

extension GroupActivitiesColorsViewsController: GroupActivityHandlerDelegate {

    func stateChanged() {

        DispatchQueue.main.async {

            self.configureConnectButton()

            if let refreshButton = self.refreshButton {
                self.refreshTapped(refreshButton)
            }
        }
    }

    func update<M: GroupActivityMessage>(message: M) {

        // make certain the message is the right type
        guard let message = message as? ChooseColorMessage else {

            preconditionFailure("Updated with a GroupActivityMessage that is not a ChooseColorMessage!")
        }

        DispatchQueue.main.async {

            self.displayColor = message.fileName
            self.displayString?.text = message.title
            self.generalStatusLabel?.text = nil
            self.connectButton?.isEnabled = !self.isConnected
        }
    }

    func report(error: Error) {

        DispatchQueue.main.async {

            self.generalStatusLabel?.text = error.localizedDescription
        }
    }

    private func configureConnectButton() {

        DispatchQueue.main.async {

            let name = self.isConnected ? "person.2.fill" : "person.2"
            let image = UIImage( systemName: name, compatibleWith: self.view.traitCollection)
            let text = self.isConnected ? "Disconnect" : "Connect"

            print("canConnect:\(self.canConnect) isConnected:\(self.isConnected)")

            self.connectButton?.setImage(image, for: .normal)
            self.connectButton?.setTitle(text, for: .normal)

            self.connectButton?.isEnabled = self.canConnect && !self.isConnected
        }
    }
}
