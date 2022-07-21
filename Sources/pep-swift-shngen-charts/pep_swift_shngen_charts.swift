import SwiftUI
import Foundation

@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
public struct BarChartView: View {
    var chartData: [BarChartData]
    var highRange: Double
    var maxRange: Double
    var diff: Double
    let frameHeight: Double = 250
    var frameWidth: Double
    var barWidth: Double
    var barBackgroundColor: Color
    var barForegroundColor: Color
    var barCornerRadius: Double
    var x_axis_fontColor: Color
    var y_axis_fontColor: Color
//    var barChartRepresentation: String
//    var showLineChart: Bool
//    var lineChartColor: Color
//    var lineWidth: Double
//    var lineChartRepresentation: String
    
    //, barChartRepresentation: String, showLineChart: Bool, lineChartColor: Color, lineWidth: Double, lineChartRepresentation: String
    
    public init(chartData: [BarChartData], highRange: Double, maxRange: Double, diff: Double, frameWidth: Double, barWidth: Double, barBackgroundColor: Color, barForegroundColor: Color, barCornerRadius: Double, x_axis_fontColor: Color, y_axis_fontColor: Color) {
        self.chartData = chartData
        self.highRange = highRange
        self.maxRange = maxRange
        self.diff = diff
        self.frameWidth = frameWidth
        self.barWidth = barWidth
        self.barBackgroundColor = barBackgroundColor
        self.barForegroundColor = barForegroundColor
        self.barCornerRadius = barCornerRadius
        self.x_axis_fontColor = x_axis_fontColor
        self.y_axis_fontColor = y_axis_fontColor
//        self.barChartRepresentation = barChartRepresentation
//        self.showLineChart = showLineChart
//        self.lineChartColor = lineChartColor
//        self.lineWidth = lineWidth
//        self.lineChartRepresentation = lineChartRepresentation
    }
    
    public var body: some View {
//        ZStack {
//            VStack(alignment: .leading) {
//                HStack(alignment: .center) {
//                    Spacer()
//                    Circle()
//                        .fill(barForegroundColor)
//                        .frame(width: 9, height: 9)
//                    Text(barChartRepresentation)
//                    Circle()
//                        .fill(lineChartColor)
//                        .frame(width: 9, height: 9)
//                    Text(lineChartRepresentation)
//                }
//                .padding()

                HStack(alignment: .lastTextBaseline) {
                    VStack {
                        ForEach(Array(stride(from: 0, to: highRange, by: diff)).reversed(), id: \.self) { index in // (Step == 5) not 1
                            Spacer()
                            Text("$\(Int(index))").foregroundColor(y_axis_fontColor)
                            //.regular(size: 11.0, color: SPColor.lightGreyText)
                            Spacer()
                        }
                    }
                    .offset(y: -20)
                    ForEach(chartData, id: \.self) { val in
                        Spacer()
                        let yvalue = Swift.min(CGFloat(Double((Int(frameHeight) * val.y_axis))/maxRange), frameHeight)
                        Group {
                            VStack {
                                ZStack(alignment: .bottom) {
                                    Rectangle()
                                        .fill(barBackgroundColor)
                                        .frame(width: barWidth, height: frameHeight)
                                        .cornerRadius(barCornerRadius)
                                    Rectangle()
                                        .fill(barForegroundColor)
                                        .frame(width: barWidth, height: CGFloat(yvalue))
                                        .cornerRadius(barCornerRadius)
                                }
                                Text("\(val.x_axis)").foregroundColor(x_axis_fontColor)
                                //                                    .regular(size: 11.0, color: x_axis_fontColor)
                            }
                        }
                        Spacer()
                    }
                }
                .frame(width: frameWidth + 60, height: 300)
            //}
//            if showLineChart {
//                LineChartView(dataPoints: self.linePoints(data: self.chartData), lineColor: lineChartColor, lineWidth: lineWidth, outerCircleColor: .blue, innerCircleColor: .red)
//            }
//        }
    }
    
    private func linePoints(data: [BarChartData]) -> [Double] {
        var arrPoints = [Double]()
        for val in data {
            arrPoints.append(Double(val.y_axis))
        }
        return arrPoints
    }
}

// MARK: ChartModelClass
@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
public struct BarChartData: Identifiable, Hashable {
    public var id = UUID()
    var x_axis: String
    var y_axis: Int
    
    public init(x_axis: String, y_axis: Int) {
        self.x_axis = x_axis
        self.y_axis = y_axis
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
