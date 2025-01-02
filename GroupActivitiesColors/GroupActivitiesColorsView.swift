// GroupActivitiesColorsView.swift
//
// Created by Bob Wakefield on 12/13/24.
// for GroupActivitiesColors
//
// Using Swift 6.0
// Running on macOS 15.1

import UIKit

class GroupActivitiesColorsView: UIView {

    #if os(visionOS)
    private let topPadding: CGFloat = 32
    private let bottomPadding: CGFloat = 32
    private let minTouchTargetWidth: CGFloat = 60
    private let minTouchTargetHeight: CGFloat = 60
    #else
    private let topPadding: CGFloat = 0
    private let bottomPadding: CGFloat = 0
    private let minTouchTargetWidth: CGFloat = 44
    private let minTouchTargetHeight: CGFloat = 44
    #endif

    let leftPadding: CGFloat = 16
    let rightPadding: CGFloat = 16
    let verticalSpacing: CGFloat = 8

    override init(frame: CGRect) {

        super.init(frame: frame)

        setup(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // <------------- UI Elements --------------->

    private lazy var mainTitleLabel: UILabel = buildLabel(text: "Group Activities Colors", style: .title1, alignment: .center)

    private lazy var scrollEnvelope: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()

    private func buildLabel(text: String, style: UIFont.TextStyle = .body, alignment: NSTextAlignment = .natural) -> UILabel {
        let label = UILabel()
        label.contentMode = .left
        label.text = text
        label.textAlignment = alignment
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .preferredFont(forTextStyle: style)
        return label
    }

    lazy var eligibilityStatusLabel = buildLabel(text: "Ineligible")
    lazy var sessionStatusLabel = buildLabel(text: "No session")
    lazy var participantsStatusLabel = buildLabel(text: "0 participants")
    lazy var generalStatusLabel: UILabel = buildLabel(text: "Normal")

    private lazy var copyrightLabel: UILabel = buildLabel(text: "2024 Cockleburr Software", alignment: .center)

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isMultipleTouchEnabled = true
        scrollView.contentMode = .scaleToFill
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var scrollContents: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()

    private lazy var statusDisplayStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .scaleAspectFit
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var statusStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.contentMode = .scaleAspectFit
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitle("Refresh", for: .normal)
        return button
    }()

    private lazy var colorButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.contentMode = .scaleAspectFit
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var currentColorView: UIView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var displayColorName: String = ""
    var displayColor: String? {
        set {
            displayColorName = newValue ?? ""
            currentColorView.backgroundColor = nametoColor(name: displayColorName)
         }

        get {
            displayColorName
        }
    }

    lazy var currentColorLabel: UILabel = buildLabel(text: "No Color Selected", alignment: .center)

    lazy var connectButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.setTitle("Connect", for: .normal)
        return button
    }()

    private func buildColorButton(colorName: String, title: String) -> UIButton {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle(title, for: .normal)
        button.setTitleColor(nametoColor(name: colorName), for: .normal)
        button.backgroundColor = .black
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = colorName
        button.accessibilityLabel = title

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: minTouchTargetWidth),
            button.heightAnchor.constraint(equalToConstant: minTouchTargetHeight),
          ])

        return button
    }

    private lazy var buttonColor1: UIButton =
        buildColorButton(colorName: "red", title: "Red")

    private lazy var buttonColor2: UIButton =
        buildColorButton(colorName: "orange", title: "Orange")

    private lazy var buttonColor3: UIButton =
        buildColorButton(colorName: "yellow", title: "Yellow")

    private lazy var buttonColor4: UIButton =
        buildColorButton(colorName: "green", title: "Green")

    private lazy var buttonColor5: UIButton =
        buildColorButton(colorName: "blue", title: "Blue")

    private lazy var buttonColor6: UIButton =
        buildColorButton(colorName: "indigo", title: "Indigo")

    private lazy var buttonColor7: UIButton =
        buildColorButton(colorName: "violet", title: "Violet")

    lazy var colorButtons: [UIButton] = [
        buttonColor1, buttonColor2, buttonColor3, buttonColor4, buttonColor5, buttonColor6, buttonColor7,
    ]

    // <------------- View Hierachy --------------->

    func addSubviews(to view: UIView) {

        view.addSubview(mainTitleLabel)
        view.addSubview(copyrightLabel)
        view.addSubview(scrollEnvelope)
        view.addSubview(statusStack)

        scrollEnvelope.addSubview(scrollView)

        scrollView.addSubview(scrollContents)

        scrollContents.addSubview(colorButtonStack)
        scrollContents.addSubview(currentColorView)
        scrollContents.addSubview(currentColorLabel)
        scrollContents.addSubview(connectButton)

        colorButtonStack.addArrangedSubview(buttonColor1)
        colorButtonStack.addArrangedSubview(buttonColor2)
        colorButtonStack.addArrangedSubview(buttonColor3)
        colorButtonStack.addArrangedSubview(buttonColor4)
        colorButtonStack.addArrangedSubview(buttonColor5)
        colorButtonStack.addArrangedSubview(buttonColor6)
        colorButtonStack.addArrangedSubview(buttonColor7)

        statusDisplayStack.addArrangedSubview(eligibilityStatusLabel)
        statusDisplayStack.addArrangedSubview(sessionStatusLabel)
        statusDisplayStack.addArrangedSubview(participantsStatusLabel)
        statusDisplayStack.addArrangedSubview(generalStatusLabel)

        statusStack.addArrangedSubview(statusDisplayStack)
        statusStack.addArrangedSubview(refreshButton)
    }

    // <------------- Constrains --------------->

    func addConstraints(to view: UIView) {

        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor),

            copyrightLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: verticalSpacing),
            copyrightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollEnvelope.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: verticalSpacing),
            scrollEnvelope.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            view.trailingAnchor.constraint(equalTo: scrollEnvelope.trailingAnchor, constant: rightPadding),

            statusStack.topAnchor.constraint(equalTo: scrollEnvelope.bottomAnchor, constant: verticalSpacing),
            statusStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            view.trailingAnchor.constraint(equalTo: statusStack.trailingAnchor, constant: rightPadding),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: statusStack.bottomAnchor, constant: bottomPadding),

            scrollView.topAnchor.constraint(equalTo: scrollEnvelope.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: scrollEnvelope.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: scrollEnvelope.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: scrollEnvelope.trailingAnchor),

            scrollContents.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContents.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContents.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContents.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContents.widthAnchor.constraint(equalTo: scrollEnvelope.widthAnchor),
            scrollContents.heightAnchor.constraint(greaterThanOrEqualTo: scrollEnvelope.heightAnchor),

            colorButtonStack.topAnchor.constraint(equalTo: scrollContents.topAnchor),
            colorButtonStack.leadingAnchor.constraint(equalTo: scrollContents.leadingAnchor),
            colorButtonStack.centerXAnchor.constraint(equalTo: scrollContents.centerXAnchor),

            currentColorView.topAnchor.constraint(equalTo: colorButtonStack.bottomAnchor, constant: verticalSpacing),
            currentColorView.leadingAnchor.constraint(equalTo: scrollContents.leadingAnchor),
            scrollContents.trailingAnchor.constraint(equalTo: currentColorView.trailingAnchor),
            currentColorView.centerXAnchor.constraint(equalTo: scrollContents.centerXAnchor),
            currentColorView.heightAnchor.constraint(equalToConstant: minTouchTargetHeight),
  
            currentColorLabel.topAnchor.constraint(equalTo: currentColorView.bottomAnchor, constant: verticalSpacing),
            currentColorLabel.leadingAnchor.constraint(equalTo: scrollContents.leadingAnchor),
            currentColorLabel.trailingAnchor.constraint(equalTo: scrollContents.trailingAnchor),

            connectButton.topAnchor.constraint(greaterThanOrEqualTo: currentColorLabel.bottomAnchor, constant: verticalSpacing),
            scrollContents.bottomAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: verticalSpacing),
            connectButton.leadingAnchor.constraint(equalTo: scrollContents.leadingAnchor),
            scrollContents.trailingAnchor.constraint(equalTo: connectButton.trailingAnchor),
        ])
    }

    // <------------- Base View Properties --------------->

    func setup(view: UIView) {

        addSubviews(to: view)
        addConstraints(to: view)

        view.backgroundColor = .systemBackground
        statusStack.backgroundColor = .secondarySystemBackground
    }

    private func nametoColor(name: String) -> UIColor {
        switch name {
        case "red": return .systemRed
        case "orange": return .systemOrange
        case "yellow": return .systemYellow
        case "green": return .systemGreen
        case "blue": return .systemBlue
        case "indigo": return .systemIndigo
        case "violet": return UIColor(red: 148, green: 0, blue: 211, alpha: 1)
        default: return .systemBackground
        }
    }
}
