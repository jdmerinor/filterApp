import UIKit



//Defines the different kinds of effects that can be used in the applyEffect method
public enum effectsType {
    case brightness(intensity: Float , times: Int)
    case contrast(intensity: Float , times: Int)
    case grayScale (intensity: Float, times: Int)
    case increaseGreen (intensity: Float, times : Int)
    case increaseRed (intensity: Float, times : Int)
    case increaseBlue (intensity: Float, times : Int)
    case blackAndWhite (intensity: Float, times : Int)
}

//Father class that defines the basic concept of a filter, so it has the intensity and the name


//Protocol that force them to create a filter method that recieves an image

public protocol filter{
    var intensity : Float {get set}
    var name : String {get set}
    
    init (intensity : Float, name: String)
    
    func filter(inout image : UIImage)
}

//Class of filter that let the user make the picture go grayScale
class GrayScales: filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        //It will make the picture go grayscale
        
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y * imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                let average = UInt8(max(0, min(255,((Int(pixel.blue) + Int(pixel.green) + Int(pixel.red))/3) + Int(100*intensity))))
                average
                pixel.blue = average
                pixel.red = average
                pixel.green = average
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
}

//Class of filter that let the user make the picture increase the blue of the pixels that have the blue under the intensity level
class IncreaseBlue : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                if pixel.blue <= UInt8(Int(254*intensity)) {
                    pixel.blue = 255
                }
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}

//Class of filter that let the user make the picture increase the blue of the pixels that have the red under the intensity level
class IncreaseRed : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                if pixel.red <= UInt8(Int(254*intensity)) {
                    pixel.red = 255
                }
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}


//Class of filter that let the user make the picture increase the green of the pixels that have the blue under the intensity level
class IncreaseGreen : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                if pixel.green <= UInt8(Int(254*intensity)) {
                    pixel.green = 255
                }
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}

//Class of filter that let the user increase the bright in a instensity factor
class IncreaseBright : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                pixel.green = UInt8(max(0,min(255, Int(pixel.green) + Int(intensity*128))))
                pixel.red = UInt8(max(0,min(255, Int(pixel.red) + Int(intensity*128))))
                pixel.blue = UInt8(max(0,min(255, Int(pixel.blue) + Int(intensity*128))))
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}

//Class of filter that let the user increase the contrast in a instensity factor
class IncreaseConstrast : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                pixel.green = UInt8(max(0,min(255, Int(Float(Int(pixel.green)-128) * intensity*2 + 128))))
                pixel.red = UInt8(max(0,min(255, Int(Float(Int(pixel.red) - 128) * intensity*2 + 128))))
                pixel.blue = UInt8(max(0,min(255, Int(Float(Int(pixel.blue) - 128) * intensity*2 + 128))))
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}


//Class of filter that let the user increase the contrast in a instensity factor
class convert3Bit : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){
        
        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y*imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                pixel.green = UInt8(Int(pixel.green/128) * 255)
                pixel.red = UInt8(Int(pixel.red/128) * 255)
                pixel.blue = UInt8(Int(pixel.blue/128) * 255)
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
    }
    
}





//It makes the picture go black and white according to the intensity level defined
class BlackAndWhite : filter {
    
    var intensity : Float
    var name : String
    
    required init(intensity: Float, name: String) {
        self.intensity  = intensity
        self.name = name
    }
    
    func filter(inout imagen: UIImage){


        let imagenProc : RGBAImage = RGBAImage.init(image: imagen)!
        for x in 0 ..< imagenProc.width{
            for y in 0 ..< imagenProc.height{
                let posicionPixel = x + y * imagenProc.width
                var pixel = imagenProc.pixels[posicionPixel]
                let average = UInt8((Int(pixel.blue) + Int(pixel.green) + Int(pixel.red))/3)
                if average >= UInt8(Int(200*intensity)){
                    pixel.blue = 255
                    pixel.red = 255
                    pixel.green = 255
                }else{
                    pixel.blue = 0
                    pixel.red = 0
                    pixel.green = 0
                    
                }
                imagenProc.pixels[posicionPixel] = pixel
            }
        }
        imagen = imagenProc.toUIImage()!
        
    }
    
}






//This is the class that acts as a controller so it needs a picture as an attribute and that image is going to be the one that will receive the effects
public class imageProcessor {
    var imagen : UIImage?
    
    //Constructor or initialicer
    public init(imagen : UIImage) { //constructor con argumentos
        self.imagen = imagen
    }
    
    
    public func applyEffects(filters : [filter]){
        for thisFilter in filters{
            if thisFilter.intensity != 0{
                thisFilter.filter(&imagen!)
            }
            
        }
    }
    
}
