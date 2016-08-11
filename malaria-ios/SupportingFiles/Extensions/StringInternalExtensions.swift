/*
 This file was created in order to dismiss error regarding redudant protocol
 declaration, when running the app tests.
 */

extension String: CustomStringConvertible {
  public var description: String { return self }
}
