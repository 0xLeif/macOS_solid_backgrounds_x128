import Cocoa

extension NSColor {
    convenience init(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 1
            red = 1
            green = 1
            blue = 1
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
    
    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}
extension URL {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
extension NSBitmapImageRep {
    
    func saveAsPNG(fileName name: String) {
        let props: [NSBitmapImageRep.PropertyKey: Any] = [:]
        let data = representation(using: .png, properties: props)!
        do {
            let fileType = ".png"
            try data.write(to: URL(string: "\(URL.getDocumentsDirectory())/x128/\(name)\(fileType)")!, options: Data.WritingOptions.atomic)
        }catch {
            print(error.localizedDescription)
            print("!!! You need to create the folder 'x128' at \(URL.getDocumentsDirectory())x128/\(name) !!!")
        }
    }
    
    func fill(withColor color: NSColor) {
        let ctx = NSGraphicsContext(bitmapImageRep: self)
        NSGraphicsContext.current = ctx
        
        color.set()
        let vertices =  [
            NSPoint(x: 0, y: 0),
            NSPoint(x: 128, y: 0),
            NSPoint(x: 128, y: 128),
            NSPoint(x: 0, y: 128)
        ]
        let path = NSBezierPath()
        
        path.move(to: vertices.first!)
        vertices.forEach{ path.line(to: $0) }
        
        path.stroke()
        path.fill()
    }
}
protocol Saveable {
    func createPNG()
}
struct NamedColor {
    let name: String
    let color: NSColor
}
struct UnnamedColor {
    let color: NSColor
    init(hexString hex: String) {
        color = NSColor(hexString: hex)
    }
}
extension UnnamedColor: Saveable {
    func createPNG() {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 128, pixelsHigh: 128, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        bitmap.fill(withColor: color)
        bitmap.saveAsPNG(fileName: color.hexString)
    }
}
extension NamedColor: Saveable {
    func createPNG() {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 128, pixelsHigh: 128, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        bitmap.fill(withColor: color)
        bitmap.saveAsPNG(fileName: name)
    }
}

//MARK: Array of UnnamedColors to export as PNG

[
    "1abc9c",
    "16a085",
    "2ecc71",
    "27ae60",
    "3498db",
    "2980b9",
    "9b59b6",
    "8e44ad",
    "34495e",
    "2c3e50",
    "f1c40f",
    "f39c12",
    "e67e22",
    "d35400",
    "e74c3c",
    "c0392b",
    "ecf0f1",
    "bdc3c7",
    "95a5a6",
    "7f8c8d",
    "394c81",
    "bf263c",
    "d35400",
    "ebd6bc",
    "967adc",
    "ffb3a7",
    "000000"
]
    .forEach{ UnnamedColor(hexString: $0).createPNG() }
