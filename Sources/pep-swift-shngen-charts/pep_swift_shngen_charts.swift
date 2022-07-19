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



// MARK: LineChartView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct LineChartView: View {
    
    var dataPoints: [Double]
    var lineColor: Color = .yellow
    var lineWidth: CGFloat = 4.0
    var outerCircleColor: Color = .red
    var innerCircleColor: Color = .white
    
    public var body: some View {
        ZStack {
            if #available(macOS 14.0, *) {
                LineView(dataPoints: dataPoints, lineWidth: lineWidth)
                    .accentColor(lineColor)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


// MARK: LineView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct LineView: View {
    var dataPoints: [Double]
    var lineWidth: CGFloat
    var highestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
                
                for index in 1..<dataPoints.count {
                    path.addLine(to: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * self.ratio(for: index)))
                }
            }
            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
        }
        .padding(.vertical)
    }
    
    private func ratio(for index: Int) -> Double {
        1 - (dataPoints[index] / highestPoint)
    }
}


// MARK: LineChartCircleView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
struct LineChartCircleView: View {
    var dataPoints: [Double]
    var radius: CGFloat
    
    var highestPoint: Double {
        let max = dataPoints.max() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))
                
                path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                            radius: radius, startAngle: .zero,
                            endAngle: .degrees(360.0), clockwise: false)
                
                for index in 1..<dataPoints.count {
                    path.move(to: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * dataPoints[index] / highestPoint))
                    
                    path.addArc(center: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * self.ratio(for: index)),
                                radius: radius, startAngle: .zero,
                                endAngle: .degrees(360.0), clockwise: false)
                }
            }
            .stroke(Color.accentColor, lineWidth: 2)
        }
        .padding(.vertical)
    }
    
    private func ratio(for index: Int) -> Double {
        1 - (dataPoints[index] / highestPoint)
    }
}
