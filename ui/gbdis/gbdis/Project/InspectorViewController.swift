//
//  EditorViewController.swift
//  gbdisui
//
//  Created by Jeff Verkoeyen on 12/2/20.
//

import Foundation

final class InspectorEditorViewController: TabViewController, TabSelectable {
  let deselectedTabImage = NSImage(systemSymbolName: "pencil.circle", accessibilityDescription: nil)!
  let selectedTabImage = NSImage(systemSymbolName: "pencil.circle.fill", accessibilityDescription: nil)!
}

final class InspectorViewController: NSViewController {
  let document: ProjectDocument

  let tabViewController = TabViewController()

  init(document: ProjectDocument) {
    self.document = document

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var regionEditorViewController: RegionEditorViewController {
    return (tabViewController.tabViewController.tabViewItems[0].viewController as! TabViewController).tabViewController.tabViewItems[0].viewController as! RegionEditorViewController
  }

  override func loadView() {
    view = NSView()

    tabViewController.view.translatesAutoresizingMaskIntoConstraints = false

    let editorTabViewController = InspectorEditorViewController()
    editorTabViewController.tabViewController.addTabViewItem(NSTabViewItem(viewController: RegionEditorViewController(document: document)))
    editorTabViewController.tabViewController.addTabViewItem(NSTabViewItem(viewController: DataTypeEditorViewController(document: document)))
    editorTabViewController.tabViewController.addTabViewItem(NSTabViewItem(viewController: GlobalEditorViewController(document: document)))
    tabViewController.tabViewController.addTabViewItem(NSTabViewItem(viewController: editorTabViewController))
    tabViewController.tabViewController.addTabViewItem(NSTabViewItem(viewController: RegionInspectorViewController(document: document)))

    addChild(tabViewController)
    view.addSubview(tabViewController.view)

    tabViewController.setUp()
    editorTabViewController.setUp()

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      tabViewController.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tabViewController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      tabViewController.view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      tabViewController.view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
    ])
  }
}