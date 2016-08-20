import Foundation

/**
 Protocol to be called on UIVIewControllers that appeares over the context. This exists because those views don't call the usual viewWillAppear, viewDidAppear, etc. Usually, it is used to refresh the content of the view after the pop up is dimissed.
 */

protocol PresentsModalityDelegate {
  func onDismiss()
}