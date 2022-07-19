import SwiftUI

@available(macOS 10.15.0, *)
public struct BarChartView: View {
    public private(set) var text = "Hello, World!"

    public init() { }
    
    @available(iOS 13.0.0, *)
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Hello")
                Text("Shatadru")
                Text("How are you !!!")
            }
        }
    }
}

