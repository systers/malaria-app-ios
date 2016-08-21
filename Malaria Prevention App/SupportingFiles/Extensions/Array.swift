import Foundation

extension Array {
    func foreach(functor: (Element) -> ()) {
        for element in self {
            functor(element)
        }
    }
}