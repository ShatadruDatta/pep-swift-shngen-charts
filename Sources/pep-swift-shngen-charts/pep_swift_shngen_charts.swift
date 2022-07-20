import SwiftUI
import Foundation

@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
public struct BarChartView: View {
    public private(set) var text = "Hello, World!"
    
    public init() { }
    
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
    var lineColor: Color
    var lineWidth: CGFloat
    var outerCircleColor: Color
    var innerCircleColor: Color
    
    public init(dataPoints: [Double], lineColor: Color, lineWidth: CGFloat, outerCircleColor: Color, innerCircleColor: Color) {
        self.dataPoints = dataPoints
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.outerCircleColor = outerCircleColor
        self.innerCircleColor = innerCircleColor
    }
    
    public var body: some View {
        ZStack {
            LineView(dataPoints: dataPoints, lineWidth: lineWidth, lineColor: lineColor)
        }
    }
}


// MARK: LineView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct LineView: View {
    var dataPoints: [Double]
    var lineWidth: CGFloat
    var lineColor: Color
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
            .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
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


// MARK: CircularProgressView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)

public struct CircularProgressBar: View {
    var circleProgress: CGFloat
    var strokeBackgroundWidth: CGFloat
    var strokeForegroundWidth: CGFloat
    var strokeBackgroundColor: Color
    var strokeForegroundColor: Color
    var loadingTimeInterval: CGFloat
    var width: CGFloat
    var height: CGFloat
    var txtValue: String
    
    public init(circleProgress: CGFloat, strokeBackgroundWidth: CGFloat, strokeForegroundWidth: CGFloat, strokeBackgroundColor: Color, strokeForegroundColor: Color, loadingTimeInterval: CGFloat, width: CGFloat, height: CGFloat, txtValue: String) {
        self.circleProgress = circleProgress
        self.strokeBackgroundColor = strokeBackgroundColor
        self.strokeBackgroundWidth = strokeBackgroundWidth
        self.strokeForegroundColor = strokeForegroundColor
        self.strokeForegroundWidth = strokeForegroundWidth
        self.loadingTimeInterval = loadingTimeInterval
        self.width = width
        self.height = height
        self.txtValue = txtValue
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(strokeBackgroundColor, lineWidth: strokeBackgroundWidth)
                    .frame(width: width, height: height)
                Circle()
                    .trim(from: 0.0, to: circleProgress)
                    .stroke(strokeForegroundColor, lineWidth: strokeForegroundWidth)
                    .frame(width: width, height: height)
                    .rotationEffect(Angle(degrees: -90))
                Text(txtValue)
            }
        }
    }
}


// MARK: PieChartView
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct PieChartView: View {
    var pieData: [PieChartData]
    var width: CGFloat
    var height: CGFloat
    
    public init(pieData: [PieChartData], width: CGFloat, height: CGFloat) {
        self.pieData = pieData
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<pieData.count) { index in
                let currentData = pieData[index]
                let currentEnddegree = currentData.percent * 360
                let lastDegree = pieData.prefix(index).map {
                    $0.percent
                }.reduce(0, +) * 360
                
                ZStack {
                    PiceOfPie(startDegree: lastDegree, endDegree: lastDegree + currentEnddegree)
                        .fill(currentData.color)
                    GeometryReader { geometry in
                        Text(currentData.description)
                            .position(getLabelCoordinate(in: geometry.size, for: lastDegree + currentEnddegree/2))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(width: width, height: height, alignment: .leading) // 240
        
    }
    
    private func getLabelCoordinate(in geoSize: CGSize, for degree: Double) -> CGPoint {
        let center = CGPoint(x: geoSize.width / 2, y: geoSize.height / 2)
        let radius = geoSize.width / 3
        
        let yCoordinate = radius * sin(CGFloat(degree) * (CGFloat.pi / 180))
        let xCoordinate = radius * cos(CGFloat(degree) * (CGFloat.pi / 180))
        return CGPoint(x: center.x + xCoordinate, y: center.y + yCoordinate)
    }
}

// MARK: PieDraw
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct PiceOfPie: Shape {
    let startDegree: Double
    let endDegree: Double
    public func path(in rect: CGRect) -> Path {
        Path { pie in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            pie.move(to: center)
            pie.addArc(center: center, radius: rect.width/2, startAngle: Angle(degrees: startDegree), endAngle: Angle(degrees: endDegree), clockwise: false)
            pie.closeSubpath()
        }
    }
}


// MARK: PieModelClass
@available(macOS 10.15, *)
@available(iOS 13.0.0, *)
public struct PieChartData: Hashable {
    var percent: Double
    var description: String
    var color: Color
    
    public init(percent: Double, description: String, color: Color) {
        self.percent = percent
        self.description = description
        self.color = color
    }
}
