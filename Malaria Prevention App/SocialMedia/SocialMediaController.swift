/// Protocol for view controllers who can share to social media.

protocol SocialMediaController {
  func share(socialItem: SocialShareable, toMedia: SocialMediaType)
}
